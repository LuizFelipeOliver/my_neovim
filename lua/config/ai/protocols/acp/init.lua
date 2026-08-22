local stdio = require("config.ai.protocols.stdio")

local M = {}
local protocol_version = 1

function M.start(options)
	if type(options) ~= "table" or type(options.command) ~= "string" then
		return nil, "A command is required"
	end

	local next_id = 0
	local pending = {}
	local buffer = ""
	local initialized = false
	local agent_capabilities
	local closed = false
	local process
	local send
	local client = {}

	local function handle_message(message)
		if type(message) ~= "table" then
			return
		end

		if message.id ~= nil and message.method == nil then
			local callback = pending[message.id]
			pending[message.id] = nil

			if callback then
				if message.error then
					callback(nil, message.error.message or "Unknown ACP error")
				else
					callback(message.result)
				end
			end
			return
		end

		if not message.method then
			return
		end

		if message.id ~= nil then
			if options.on_request then
				local answered = false
				options.on_request(message.method, message.params, function(result, error)
					if answered then
						return nil, "ACP request has already been answered"
					end
					answered = true

					if error then
						return send({ jsonrpc = "2.0", id = message.id, error = error })
					end

					return send({ jsonrpc = "2.0", id = message.id, result = result })
				end)
			else
				send({
					jsonrpc = "2.0",
					id = message.id,
					error = { code = -32601, message = "Method not found: " .. message.method },
				})
			end
			return
		end

		if options.on_notification then
			options.on_notification(message.method, message.params)
		end
	end

	local function handle_stdout(data)
		buffer = buffer .. data

		while true do
			local newline = buffer:find("\n", 1, true)
			if not newline then
				break
			end

			local line = buffer:sub(1, newline - 1)
			buffer = buffer:sub(newline + 1)

			if line ~= "" then
				local ok, message = pcall(vim.json.decode, line)
				if ok then
					handle_message(message)
				elseif options.on_error then
					options.on_error("Invalid ACP message: " .. tostring(message))
				end
			end
		end
	end

	local error_message
	process, error_message = stdio.start({
		command = options.command,
		args = options.args,
		on_stdout = handle_stdout,
		on_stderr = options.on_stderr,
		on_error = options.on_error,
		on_exit = function(code, signal)
			closed = true
			for _, callback in pairs(pending) do
				callback(nil, "ACP process exited")
			end
			pending = {}

			if options.on_exit then
				options.on_exit(code, signal)
			end
		end,
	})

	if not process then
		return nil, error_message
	end

	send = function(message)
		if closed then
			return nil, "ACP process is closed"
		end

		return process.write(vim.json.encode(message) .. "\n")
	end

	function client.request(method, params, callback)
		next_id = next_id + 1
		pending[next_id] = callback or function() end

		local ok, error_message = send({
			jsonrpc = "2.0",
			id = next_id,
			method = method,
			params = params or vim.empty_dict(),
		})

		if not ok then
			pending[next_id] = nil
		end

		return ok, error_message
	end

	function client.notify(method, params)
		return send({
			jsonrpc = "2.0",
			method = method,
			params = params or vim.empty_dict(),
		})
	end

	function client.initialize(callback)
		callback = callback or function() end

		return client.request("initialize", {
			protocolVersion = protocol_version,
			clientCapabilities = options.client_capabilities or vim.empty_dict(),
			clientInfo = options.client_info or { name = "nvim", title = "Neovim" },
		}, function(result, error_message)
			if error_message then
				callback(nil, error_message)
				return
			end

			if type(result) ~= "table" or type(result.protocolVersion) ~= "number" then
				callback(nil, "Invalid ACP initialize response")
				return
			end

			if result.protocolVersion ~= protocol_version then
				callback(nil, "Unsupported ACP version: " .. tostring(result.protocolVersion))
				return
			end

			initialized = true
			agent_capabilities = result.agentCapabilities
			callback(result)
		end)
	end

	function client.new_session(params, callback)
		if not initialized then
			return nil, "ACP is not initialized"
		end

		return client.request("session/new", params, callback)
	end

	function client.get_capabilities()
		return agent_capabilities
	end

	function client.close()
		if not closed then
			closed = true
			process.close()
		end
	end

	return client
end

return M

local uv = vim.uv
local M = {}

local function close(handle)
	if handle and not handle:is_closing() then
		handle:close()
	end
end

local function schedule(callback, ...)
	if not callback then
		return
	end

	local arguments = { ... }
	vim.schedule(function()
		callback(unpack(arguments))
	end)
end

function M.start(options)
	if type(options) ~= "table" or type(options.command) ~= "string" then
		return nil, "A command is required"
	end

	local stdin = uv.new_pipe(false)
	local stdout = uv.new_pipe(false)
	local stderr = uv.new_pipe(false)
	local process, error_message = uv.spawn(options.command, {
		args = options.args or {},
		stdio = { stdin, stdout, stderr },
	}, function(code, signal)
		close(stdin)
		close(stdout)
		close(stderr)
		close(process)
		schedule(options.on_exit, code, signal)
	end)

	if not process then
		close(stdin)
		close(stdout)
		close(stderr)
		return nil, error_message
	end

	local function read(pipe, callback)
		uv.read_start(pipe, function(error, data)
			if error then
				schedule(options.on_error, error)
				return
			end

			if data then
				schedule(callback, data)
			else
				close(pipe)
			end
		end)
	end

	read(stdout, options.on_stdout)
	read(stderr, options.on_stderr)

	return {
		write = function(data)
			if process:is_closing() or stdin:is_closing() then
				return nil, "Process is closed"
			end

			stdin:write(data, function(error)
				if error then
					schedule(options.on_error, error)
				end
			end)
			return true
		end,
		close = function()
			close(stdin)
			if not process:is_closing() then
				process:kill("sigterm")
			end
		end,
	}
end

return M

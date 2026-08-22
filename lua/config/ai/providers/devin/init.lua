local M = {}
local acp = require("config.ai.protocols.acp")
local settings = require("config.ai.providers.devin.settings")

local runtimes = {
	plan = { pending_permissions = {} },
	edit = { pending_permissions = {} },
}
local last_plan
local current_mode = "plan"

local function notify_error(message)
	vim.notify("Devin: " .. message, vim.log.levels.ERROR)
end

local function cancel_pending_permissions(runtime)
	for respond in pairs(runtime.pending_permissions) do
		runtime.pending_permissions[respond] = nil
		respond({ outcome = { outcome = "cancelled" } })
	end
end

local function reset_runtime(runtime)
	runtime.client = nil
	runtime.session_id = nil
	runtime.starting = false
	runtime.startup_callback = nil
	runtime.prompt_active = false
	runtime.active_handlers = nil
end

local function permission_title(params)
	local tool_call = params.toolCall or {}
	local title = tool_call.title or "Tool call"
	local kind = tool_call.kind and (" (" .. tool_call.kind .. ")") or ""
	return "Devin permission: " .. title .. kind
end

local function handle_request(runtime, method, params, respond)
	if method ~= "session/request_permission" then
		respond(nil, { code = -32601, message = "Method not found: " .. method })
		return
	end

	if type(params) ~= "table" or type(params.options) ~= "table" then
		respond(nil, { code = -32602, message = "Invalid permission request" })
		return
	end

	if params.sessionId ~= runtime.session_id then
		respond({ outcome = { outcome = "cancelled" } })
		return
	end

	runtime.pending_permissions[respond] = true
	vim.ui.select(params.options, {
		prompt = permission_title(params),
		format_item = function(option)
			return (option.name or option.optionId or "Permission option") .. " [" .. (option.kind or "unknown") .. "]"
		end,
	}, function(option)
		if not runtime.pending_permissions[respond] then
			return
		end

		runtime.pending_permissions[respond] = nil
		if option and type(option.optionId) == "string" then
			respond({ outcome = { outcome = "selected", optionId = option.optionId } })
		else
			respond({ outcome = { outcome = "cancelled" } })
		end
	end)
end

local function start_session(kind, callback)
	local runtime = runtimes[kind]
	if runtime.client and runtime.session_id then
		callback(true)
		return
	end

	if runtime.starting then
		callback(nil, "Devin " .. kind .. " session is starting")
		return
	end

	runtime.starting = true
	runtime.startup_callback = callback
	local args = { "--permission-mode", "auto", "--sandbox" }
	if type(settings.model) == "string" and settings.model ~= "" then
		vim.list_extend(args, { "--model", settings.model })
	end
	table.insert(args, "acp")
	if kind == "plan" then
		vim.list_extend(args, { "--agent-type", "review" })
	end

	local client, error_message = acp.start({
		command = "devin",
		args = args,
		client_capabilities = vim.empty_dict(),
		client_info = { name = "nvim", title = "Neovim" },
		on_request = function(method, params, respond)
			handle_request(runtime, method, params, respond)
		end,
		on_notification = function(method, params)
			if method == "session/update" and params and params.sessionId == runtime.session_id and runtime.active_handlers and runtime.active_handlers.on_update then
				runtime.active_handlers.on_update(params.update)
			end
		end,
		on_error = function(error)
			notify_error(tostring(error))
		end,
		on_exit = function()
			local start_callback = runtime.startup_callback
			local handlers = runtime.active_handlers
			local was_active = runtime.prompt_active
			cancel_pending_permissions(runtime)
			reset_runtime(runtime)
			if start_callback then
				start_callback(nil, "Devin ACP process exited")
			elseif was_active and handlers and handlers.on_error then
				handlers.on_error("Devin ACP process exited")
			end
		end,
	})

	if not client then
		runtime.starting = false
		runtime.startup_callback = nil
		callback(nil, error_message)
		return
	end

	runtime.client = client
	client.initialize(function(_, initialize_error)
		if initialize_error then
			local start_callback = runtime.startup_callback
			client.close()
			reset_runtime(runtime)
			start_callback(nil, initialize_error)
			return
		end

		local cwd = vim.uv.cwd()
		if type(cwd) ~= "string" or not vim.startswith(cwd, "/") then
			local start_callback = runtime.startup_callback
			client.close()
			reset_runtime(runtime)
			start_callback(nil, "Neovim must have an absolute working directory")
			return
		end

		client.new_session({
			cwd = cwd,
			mcpServers = {},
		}, function(session, session_error)
			if session_error or type(session) ~= "table" or type(session.sessionId) ~= "string" then
				local start_callback = runtime.startup_callback
				client.close()
				reset_runtime(runtime)
				start_callback(nil, session_error or "Invalid ACP session response")
				return
			end

			runtime.session_id = session.sessionId
			runtime.starting = false
			local start_callback = runtime.startup_callback
			runtime.startup_callback = nil
			start_callback(true)
		end)
	end)
end

local function run(kind, prompt, handlers)
	handlers = handlers or {}
	if type(prompt) ~= "string" or prompt == "" then
		return nil, "A prompt is required"
	end

	local runtime = runtimes[kind]
	if runtime.prompt_active then
		return nil, "Devin is already processing a " .. kind .. " prompt"
	end

	start_session(kind, function(_, start_error)
		if start_error then
			if handlers.on_error then
				handlers.on_error(start_error)
			else
				notify_error(start_error)
			end
			return
		end

		runtime.prompt_active = true
		runtime.active_handlers = handlers
		local ok, request_error = runtime.client.request("session/prompt", {
			sessionId = runtime.session_id,
			prompt = { { type = "text", text = prompt } },
		}, function(result, prompt_error)
			local completed_handlers = runtime.active_handlers
			runtime.prompt_active = false
			runtime.active_handlers = nil

			if prompt_error then
				if completed_handlers and completed_handlers.on_error then
					completed_handlers.on_error(prompt_error)
				else
					notify_error(prompt_error)
				end
			elseif completed_handlers and completed_handlers.on_complete then
				completed_handlers.on_complete(result)
			end
		end)

		if not ok then
			runtime.prompt_active = false
			runtime.active_handlers = nil
			if handlers.on_error then
				handlers.on_error(request_error)
			else
				notify_error(request_error)
			end
		end
	end)

	return true
end

function M.get_settings()
	return settings
end

function M.save_settings(next_settings)
	local result = vim.fn.writefile({
		"return {",
		("\tmodel = %s,"):format(next_settings.model and ("%q"):format(next_settings.model) or "nil"),
		("\tvariant = %s,"):format(next_settings.variant and ("%q"):format(next_settings.variant) or "nil"),
		"}",
		"",
	}, vim.fn.stdpath("config") .. "/lua/config/ai/providers/devin/settings.lua")

	if result ~= 0 then
		return nil, "Could not save Devin settings"
	end

	settings.model = next_settings.model
	settings.variant = next_settings.variant
	return true
end

function M.get_models()
	return {}
end

function M.get_status()
	return { mode = current_mode }
end

function M.set_mode(mode)
	if mode ~= "plan" and mode ~= "edit" then
		return nil, "AI mode must be plan or edit"
	end

	if mode == "edit" and (not last_plan or last_plan == "") then
		return nil, "Run AI Plan and wait for it to finish before switching to edit"
	end

	current_mode = mode
	return true
end

function M.toggle_mode()
	return M.set_mode(current_mode == "plan" and "edit" or "plan")
end

function M.plan(prompt, handlers)
	if type(prompt) ~= "string" or prompt == "" then
		return nil, "A prompt is required"
	end

	last_plan = nil
	current_mode = "plan"
	local chunks = {}
	local next_handlers = vim.tbl_extend("force", handlers or {}, {
		on_update = function(update)
			if update and update.sessionUpdate == "agent_message_chunk" and update.content and update.content.type == "text" then
				table.insert(chunks, update.content.text)
			end
			if handlers and handlers.on_update then
				handlers.on_update(update)
			end
		end,
		on_complete = function(result)
			last_plan = table.concat(chunks)
			if handlers and handlers.on_complete then
				handlers.on_complete(result)
			end
		end,
	})

	return run("plan", prompt, next_handlers)
end

function M.edit(prompt, handlers)
	if not last_plan or last_plan == "" then
		return nil, "Run :AIPlan and wait for it to finish before editing"
	end

	current_mode = "edit"
	return run("edit", "Plan to implement:\n" .. last_plan .. "\n\nEditing task:\n" .. prompt, handlers)
end

function M.ask(prompt, handlers)
	if current_mode == "plan" then
		return M.plan(prompt, handlers)
	end

	return M.edit(prompt, handlers)
end

function M.cancel()
	for _, runtime in pairs(runtimes) do
		cancel_pending_permissions(runtime)
		if runtime.client and runtime.session_id and runtime.prompt_active then
			runtime.client.notify("session/cancel", { sessionId = runtime.session_id })
		end
	end
	return true
end

function M.close()
	M.cancel()
	for _, runtime in pairs(runtimes) do
		local start_callback = runtime.startup_callback
		if runtime.client then
			runtime.client.close()
		end
		reset_runtime(runtime)
		if start_callback then
			start_callback(nil, "Devin ACP client closed")
		end
	end
	return true
end

return M

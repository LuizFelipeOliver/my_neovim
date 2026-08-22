local config = require("config.ai.provider")
local output_ui = require("config.ai.ui.output")
local prompt_ui = require("config.ai.ui.prompt")
local status_ui = require("config.ai.ui.status")

local function CloseProvider(name)
	local ok, provider = pcall(require, "config.ai.providers." .. name)
	if ok and provider.close then
		provider.close()
	end
end

local function ListProviders()
	return vim.fn.sort(vim.tbl_map(function(f)
		return vim.fn.fnamemodify(f, ":h:t")
	end, vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/config/ai/providers", "*/init.lua", false, true)))
end

local function SetProviders(name)
	if not vim.tbl_contains(ListProviders(), name) then
		vim.notify("AI provider not found: " .. name, vim.log.levels.ERROR)
		return
	end

	local writeProvider = vim.fn.writefile({
		"return {",
		("\tcurrent = %q,"):format(name),
		"}",
		"",
	}, vim.fn.stdpath("config") .. "/lua/config/ai/provider.lua")

	if writeProvider ~= 0 then
		vim.notify("Failed to write provider: " .. name, vim.log.levels.ERROR)
		return
	end
	if config.current ~= name then
		CloseProvider(config.current)
	end
	config.current = name
	vim.notify("AI Provider selected: " .. name, vim.log.levels.INFO)
end

local function AskAI(prompt)
	local provider = require("config.ai.providers." .. config.current)
	if not provider.ask then
		vim.notify("AI provider does not support prompts: " .. config.current, vim.log.levels.ERROR)
		return
	end

	local provider_status = provider.get_status and provider.get_status() or {}
	local mode = provider_status.mode or "ai"
	output_ui.start(mode)
	local ok, error_message = provider.ask(prompt, {
		on_update = function(update)
			if
				update
				and update.sessionUpdate == "agent_message_chunk"
				and update.content
				and update.content.type == "text"
			then
				output_ui.append(mode, update.content.text)
			end
		end,
		on_complete = function(result)
			output_ui.complete(mode, result)
		end,
		on_error = function(message)
			output_ui.error(mode, message)
		end,
	})

	if not ok then
		output_ui.error(mode, error_message)
	end
end

local function OpenAskPrompt()
	local provider = require("config.ai.providers." .. config.current)
	local provider_status = provider.get_status and provider.get_status() or {}
	prompt_ui.open(provider_status.mode or "ai", AskAI)
end

--Commands
vim.api.nvim_create_user_command("AIProvider", function(opts)
	SetProviders(opts.args)
end, {
	nargs = 1,
	complete = function(arg_lead)
		return vim.tbl_filter(function(name)
			return vim.startswith(name, arg_lead)
		end, ListProviders())
	end,
	force = true,
})

vim.api.nvim_create_user_command("AIMode", function(opts)
	local provider = require("config.ai.providers." .. config.current)
	if not provider.set_mode or (opts.args == "" and not provider.toggle_mode) then
		vim.notify("AI provider does not support modes: " .. config.current, vim.log.levels.ERROR)
		return
	end

	local ok, error_message
	if opts.args == "" then
		ok, error_message = provider.toggle_mode()
	else
		ok, error_message = provider.set_mode(opts.args)
	end
	if not ok then
		vim.notify(error_message, vim.log.levels.ERROR)
	end
end, {
	nargs = "?",
	complete = function(arg_lead)
		return vim.tbl_filter(function(mode)
			return vim.startswith(mode, arg_lead)
		end, { "plan", "edit" })
	end,
	force = true,
})

vim.api.nvim_create_user_command("AICancel", function()
	local provider = require("config.ai.providers." .. config.current)
	if provider.cancel then
		provider.cancel()
	end
end, { force = true })

vim.keymap.set("n", "<leader>aw", OpenAskPrompt, { desc = "Ai Ask" })

vim.keymap.set("n", "<leader>as", function()
	local provider = require("config.ai.providers." .. config.current)
	local settings = provider and provider.get_settings and provider.get_settings() or {}
	local provider_status = provider and provider.get_status and provider.get_status() or {}

	status_ui.toggle({
		provider = config.current or "not selected",
		model = settings.model,
		variant = settings.variant,
		mode = provider_status.mode or "not selected",
	})
end, { desc = "Ai Status" })

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = vim.api.nvim_create_augroup("config-ai", { clear = true }),
	callback = function()
		CloseProvider(config.current)
	end,
})

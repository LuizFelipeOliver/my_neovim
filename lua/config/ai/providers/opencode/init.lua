local M = {}
local settings = require("config.ai.providers.opencode.settings")

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
	}, vim.fn.stdpath("config") .. "/lua/config/ai/providers/opencode/settings.lua")

	if result ~= 0 then
		return nil, "Could not save OpenCode settings"
	end

	settings.model = next_settings.model
	settings.variant = next_settings.variant
	return true
end

function M.get_models()
	return {}
end

function M.ask(prompt, context)
	return nil, "OpenCode communication is not implemented"
end

return M

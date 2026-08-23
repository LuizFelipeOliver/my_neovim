return function()
	local helpers = require("codecompanion.adapters.acp.helpers")

	return {
		name = "devin",
		formatted_name = "Devin",
		type = "acp",

		roles = {
			llm = "assistant",
			user = "user",
		},

		commands = {
			default = {
				"devin",
				"--permission-mode",
				"auto",
				"--sandbox",
				"acp",
			},
		},

		defaults = {
			mcpServers = {},
			timeout = 20000,
		},

		parameters = {
			protocolVersion = 1,
			clientCapabilities = {
				fs = {
					readTextFile = true,
					writeTextFile = true,
				},
			},
			clientInfo = {
				name = "Neovim",
				version = vim.version().major .. "." .. vim.version().minor,
			},
		},

		handlers = {
			setup = function()
				return true
			end,
			auth = function()
				return true
			end,
			form_messages = function(self, messages, capabilities)
				return helpers.form_messages(self, messages, capabilities)
			end,
			on_exit = function() end,
		},
	}
end

return {
	{
		"olimorris/codecompanion.nvim",
		version = "^19.0.0",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{ "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle chat" },
			{ "<leader>ac", "<cmd>CodeCompanionActions<cr>", desc = "Actions" },
			{ "<leader>ar", "<cmd>CodeCompanionCodeReview<cr>", desc = "Code review" },
		},
		opts = {
			adapters = {
				acp = {
					devin = require("config.ai.devin"),
				},
			},
			display = {
				chat = {
					window = {
						layout = "vertical",
						position = "right",
					},
				},
			},
			interactions = {
				chat = {
					adapter = "devin",
				},
			},
		},
	},
}

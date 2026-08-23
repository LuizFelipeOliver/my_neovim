return {
	{
		"olimorris/codecompanion.nvim",
		version = "^19.0.0",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			adapters = {
				acp = {
					devin = require("config.ai.devin"),
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

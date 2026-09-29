return {
	"NeogitOrg/neogit",
	lazy = true,
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"sindrets/diffview.nvim",
			cmd = {
				"DiffviewOpen",
				"DiffviewClose",
				"DiffviewToggleFiles",
				"DiffviewFocusFiles",
				"DiffviewFileHistory",
				"DiffviewRefresh",
			},
			opts = {},
		},
		"nvim-telescope/telescope.nvim",
	},
	cmd = "Neogit",
	keys = {
		{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
	},
	opts = {
		kind = "tab",
		diff_viewer = "diffview",
		integrations = {
			telescope = true,
			diffview = true,
		},
	},
}

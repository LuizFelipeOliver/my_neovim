return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			local builtin = require("telescope.builtin")
			require("telescope").setup({
				defaults = require("telescope.themes").get_ivy(),
				extensions = {
					fzf = {},
				},
			})
			require("telescope").load_extension("fzf")

			vim.keymap.set("n", "<leader>fh", builtin.help_tags)
			vim.keymap.set("n", "<leader>fk", builtin.keymaps)
			vim.keymap.set("n", "<leader>fd", builtin.find_files)
			vim.keymap.set("n", "<leader>ve", function()
				builtin.find_files({
					cwd = vim.fn.stdpath("config"),
				})
			end)
			vim.keymap.set("n", "<leader>Gf", builtin.git_files)
			vim.keymap.set("n", "<leader>Gb", builtin.git_branches)

			vim.keymap.set("n", "<leader>fg", function()
				require("config.telescope.multigrep").live_multigrep()
			end, { desc = "Live multigrep" })
			vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "Marks" })
			-- LSP (gd/gr/gi/gt/gD): nativo vim.lsp.buf + ui2, sem override aqui
		end,
	},
}

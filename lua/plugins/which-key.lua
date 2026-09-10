return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		delay = 300,
		icons = {
			mappings = false,
		},
		spec = {
			{ "<leader>f", group = "Find" },
			{ "<leader>G", group = "Git" },
			{ "<leader>c", group = "Code" },
			{ "<leader>t", group = "Tools" },
			{ "<leader>v", group = "Vim/Neovim" },
			{ "<leader>d", group = "Debug" },
			{ "<space>b", group = "Buffer" },
			{ "<space>e", group = "Explorer" },
			{ "g", group = "Goto" },
			{ "ys", desc = 'Envolver (ex: ysiw")', mode = { "n", "x" } },
			{ "ds", desc = 'Remover (ex: ds")' },
			{ "cs", desc = 'Trocar (ex: cs"\')' },
			{ "gs", group = "Surround" },
			{ "gsf", desc = "Achar à direita" },
			{ "gsF", desc = "Achar à esquerda" },
			{ "gsh", desc = "Destacar" },
			{ "gsn", desc = "Nº linhas" },
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer keymaps",
		},
	},
}

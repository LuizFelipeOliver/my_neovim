return {
	{
		-- Base de configs (cmd/filetypes/roots) consumida via vim.lsp.config nativo.
		-- Sem ele, vim.lsp.config("gopls") etc. resolve nil e vim.lsp.enable() não liga nada.
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
}

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	config = function()
		require("conform").setup({
			format_on_save = {
				timeout_ms = 5000,
				lsp_fallback = true,
			},
			formatters_by_ft = {},
		})

		require("config.formatter")

		vim.keymap.set("n", "<leader>cf", function()
			require("conform").format({ async = true, lsp_fallback = true })
		end, { desc = "Format buffer" })
	end,
}

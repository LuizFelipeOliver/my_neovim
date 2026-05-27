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
		end,
	}

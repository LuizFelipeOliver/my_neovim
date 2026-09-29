require("config.lsp.go")
require("config.lsp.php")
require("config.lsp.javascript")
require("config.lsp.lua")
require("config.lsp.cpp")

vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = false,
	float = {
		border = "rounded",
		source = "if_many",
	},
})

vim.o.updatetime = 500

vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		if vim.fn.mode() ~= "n" then
			return
		end

		local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })

		if #diagnostics > 0 then
			vim.diagnostic.open_float(nil, {
				focus = false,
				focusable = false,
				scope = "cursor",
			})
			return
		end

		local hover_clients = vim.lsp.get_clients({
			bufnr = 0,
			method = "textDocument/hover",
		})

		if #hover_clients == 0 then
			return
		end

		-- focusable = false: CursorHold repetido nunca puxa o foco para o float
		vim.lsp.buf.hover({ focusable = false })
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		local opts = { buffer = args.buf }

		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

		vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	end,
})

-- Nativo 0.11+: dispensa mason-lspconfig/automatic_enable
vim.lsp.enable({ "gopls", "phpactor", "vtsls", "lua_ls", "clangd" })

return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            {
                "folke/lazydev.nvim",
                opts = {
                    library = {
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
        },
        config = function()
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

                    vim.lsp.buf.hover()
                end,
            })

            vim.lsp.config('lua_ls', {
                settings = {
                    Lua = {
                        diagnostics = { globals = { 'vim' } },
                    },
                },
            })
            local format_group = vim.api.nvim_create_augroup('LspFormatOnSave', { clear = false })

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('LspKeymaps', { clear = true }),
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client then return end

                    local opts = { buffer = args.buf }

                    -- Navigation
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

                    -- Diagnostics
                    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
                    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

                    -- Actions
                    vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, opts)
                    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

                    -- Format on save
                    if client:supports_method('textDocument/formatting') then
                        vim.api.nvim_clear_autocmds({ group = format_group, buffer = args.buf })
                        vim.api.nvim_create_autocmd('BufWritePre', {
                            group = format_group,
                            buffer = args.buf,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
                            end,
                        })
                    end
                end,
            })
        end,
    }
}

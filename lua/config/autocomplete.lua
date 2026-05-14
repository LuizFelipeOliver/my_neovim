vim.o.autocomplete = true
vim.o.completeopt = "menuone,noselect,popup"
vim.o.pumheight = 8
vim.o.pummaxwidth = 40
vim.o.pumborder = "rounded"

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("native_lsp_completion", { clear = true }),

    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        if not client then
            return
        end

        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, ev.buf, {
                autotrigger = true,
            })
        end
    end,
})

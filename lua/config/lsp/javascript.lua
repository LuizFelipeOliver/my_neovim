vim.lsp.config('vtsls', {
    settings = {
        complete_function_call = true,
        tsserver = {
            format = {
                enable = true,
            },
        },
    },
})

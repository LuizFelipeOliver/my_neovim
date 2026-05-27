vim.lsp.config('vtsls', {
    settings = {
        typescript = {
            suggest = {
                completeFunctionCalls = true,
            },
        },
        javascript = {
            suggest = {
                completeFunctionCalls = true,
            },
        },
        tsserver = {
            format = {
                enable = true,
            },
        },
    },
})

return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = true,
        config = function()
            require("nvim-treesitter").setup({
                ensure_installed = {
                    "lua",
                    "query",
                    "markdown",
                    "markdown_inline",
                    "bash",
                    "dockerfile",
                    "http",
                    "html",
                    "json",
                },
            })

            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    pcall(vim.treesitter.start)
                end,
            })
        end,
    },
}

return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
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
                    "go",
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

return {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    dependencies = {
        {
            "malewicz1337/oil-git.nvim",
            dependencies = { "stevearc/oil.nvim" },
            opts = {
                show_file_highlights = true,
                show_directory_highlights = false,
                show_ignored_files = true,
            },
        },
    },
    opts = {
        "icon"
    },
    lazy = false,
    config = function(_, opts)
        require("oil").setup(opts)
        vim.keymap.set("n", "<space>e", "<cmd>Oil<cr>", { desc = "Open Oil (current dir)" })
        vim.keymap.set("n", "<space>er", function() require("oil").open(vim.fn.getcwd()) end,
            { desc = "Open Oil (project root)" })
    end,
}

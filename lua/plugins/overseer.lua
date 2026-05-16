return {
    "stevearc/overseer.nvim",
    ---@module 'overseer'
    ---@type overseer.SetupOpts
    opts = {
        task_list = {
            direction = "bottom",
            min_height = 15,
            max_height = 20,
            default_detail = 1,
        },
    },
    keys = {
        { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run task" },
        { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle tasks" },
        { "<leader>oo", "<cmd>OverseerOpen<cr>", desc = "Open tasks" },
        { "<leader>oc", "<cmd>OverseerClose<cr>", desc = "Close tasks" },
    },
}

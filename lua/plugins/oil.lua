return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  config = function(_, opts)
    require("oil").setup(opts)
    vim.keymap.set("n", "<space>e", "<cmd>Oil<cr>", { desc = "Open Oil (current dir)" })
    vim.keymap.set("n", "<space>er", function() require("oil").open(vim.fn.getcwd()) end, { desc = "Open Oil (project root)" })
  end,
}

return {
  {
    'stevearc/oil.nvim',
    lazy = true,
    keys = {
      { "<space>e", "<cmd>Oil --float<cr>", desc = "File explorer" },
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
    opts = {
      float = {
        padding = 2,
        max_width = 100,
        max_height = 30,
        border = "rounded",
      },
      view_options = {
        show_hidden = true,
      },
    },
    dependencies = { "echasnovski/mini.nvim" },
  }
}

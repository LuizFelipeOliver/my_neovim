return {
  {
    "echasnovski/mini.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("mini.icons").setup()
      MiniIcons.mock_nvim_web_devicons()
      require("mini.statusline").setup({ use_icons = true })
      require("mini.tabline").setup()
      require("mini.pairs").setup()
      require("mini.surround").setup({
        mappings = {
          add = "ys",
          delete = "ds",
          replace = "cs",
          find = "gsf",
          find_left = "gsF",
          highlight = "gsh",
          update_n_lines = "gsn",
        },
      })
      require("mini.indentscope").setup({
        symbol = "│",
      })
      -- snippets: nativo vim.snippet (0.11+), sem mini.snippets

      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })

      vim.keymap.set("n", "<space>bc", "<cmd>bdelete<cr>", { desc = "Buffer close" })
      vim.keymap.set("n", "<space>bo", "<cmd>%bd|e#|bd#<cr>", { desc = "Close others" })
      vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Buffer previous" })
      vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Buffer next" })
    end,
  },
}

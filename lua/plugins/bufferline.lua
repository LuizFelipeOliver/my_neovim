return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "echasnovski/mini.nvim" },
    event = "VeryLazy",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          style_preset = require("bufferline").style_preset.default,
          separator_style = "thin",
          show_buffer_close_icons = true,
          show_close_icon = false,
          diagnostics = "nvim_lsp",
          always_show_bufferline = true,
          offsets = {
            {
              filetype = "oil",
              text = "File Explorer",
              highlight = "Directory",
              separator = true,
            },
          },
        },
      })

      vim.keymap.set("n", "<space>bc", "<cmd>bdelete<cr>", { desc = "Buffer close" })
      vim.keymap.set("n", "<space>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close others" })
      vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Buffer previous" })
      vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Buffer next" })
    end,
  },
}

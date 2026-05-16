return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    delay = 300,
    icons = {
      mappings = false,
    },
    spec = {
      { "<leader>f", group = "Find" },
      { "<leader>G", group = "Git" },
      { "<leader>c", group = "Code" },
      { "<leader>b", group = "Buffer" },
      { "<leader>o", group = "Overseer" },
      { "<leader>t", group = "Tests" },
      { "<leader>T", group = "Tools" },
      { "<leader>v", group = "Vim/Neovim" },
      { "<leader>d", group = "Debug" },
      { "g", group = "Goto" },
    },
  },
  keys = {
    { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" },
  },
}

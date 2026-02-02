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
      { "<leader>g", group = "Git" },
      { "<leader>R", group = "REST" },
      { "<leader>c", group = "Code" },
      { "<leader>b", group = "Buffer" },
      { "<leader>S", group = "Session" },
      { "<leader>d", group = "Debug" },
      { "g", group = "Goto" },
    },
  },
  keys = {
    { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" },
  },
}

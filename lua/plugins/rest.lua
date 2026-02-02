return {
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    config = function()
      local kulala = require("kulala")

      kulala.setup({
        display_mode = "float",
        float_options = {
          relative = "editor",
          width = 0.8,
          height = 0.8,
          border = "rounded",
        },
      })

      vim.keymap.set("n", "<space>Rr", kulala.run, { desc = "Run request" })
      vim.keymap.set("n", "<space>Ra", kulala.run_all, { desc = "Run all requests" })
      vim.keymap.set("n", "<space>Rp", kulala.jump_prev, { desc = "Previous request" })
      vim.keymap.set("n", "<space>Rn", kulala.jump_next, { desc = "Next request" })
      vim.keymap.set("n", "<space>Ri", kulala.inspect, { desc = "Inspect request" })
      vim.keymap.set("n", "<space>Rt", kulala.toggle_view, { desc = "Toggle headers/body" })
      vim.keymap.set("n", "<space>Rc", kulala.copy, { desc = "Copy as cURL" })
      vim.keymap.set("n", "<space>Rs", kulala.search, { desc = "Search requests" })
      vim.keymap.set("n", "<space>Rq", kulala.close, { desc = "Close response" })
    end,
  },
}

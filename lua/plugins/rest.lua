return {
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    config = function()
      local kulala = require("kulala")

      kulala.setup({
        display_mode = "float",
        disable_folding = true,
        float_options = {
          relative = "editor",
          width = 0.8,
          height = 0.8,
          border = "rounded",
          max_body_lines = 0,
        },
      })

      -- Desabilita folding no buffer de resposta do kulala
      vim.api.nvim_create_autocmd("BufWinEnter", {
        callback = function()
          local bufname = vim.api.nvim_buf_get_name(0)
          if bufname:match("kulala") or bufname:match("rest%-nvim") then
            vim.opt_local.foldenable = false
            vim.opt_local.foldmethod = "manual"
            vim.opt_local.foldlevel = 99
            vim.cmd("normal! zR")
          end
        end,
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

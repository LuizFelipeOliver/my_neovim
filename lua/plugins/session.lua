return {
  {
    "rmagatti/auto-session",
    lazy = false,
    config = function()
      require("auto-session").setup({
        auto_restore = true,
        auto_save = true,
        auto_create = true,
        suppressed_dirs = { "~/", "~/Downloads", "/" },
      })

      vim.keymap.set("n", "<space>Sr", "<cmd>SessionRestore<cr>", { desc = "Restore session" })
      vim.keymap.set("n", "<space>Ss", "<cmd>SessionSave<cr>", { desc = "Save session" })
      vim.keymap.set("n", "<space>Sd", "<cmd>SessionDelete<cr>", { desc = "Delete session" })
      vim.keymap.set("n", "<space>Sf", "<cmd>SessionSearch<cr>", { desc = "Search sessions" })
    end,
  },
}

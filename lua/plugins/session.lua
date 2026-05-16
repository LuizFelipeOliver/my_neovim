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
    end,
  },
}

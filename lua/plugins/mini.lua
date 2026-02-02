return {
  {
    'echasnovski/mini.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('mini.icons').setup()
      MiniIcons.mock_nvim_web_devicons()
      require('mini.statusline').setup({ use_icons = true })
      require('mini.pairs').setup()
    end,
  },
}

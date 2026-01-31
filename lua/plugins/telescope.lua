return {
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      local builtin = require('telescope.builtin')
      require('telescope').setup {
        pickers = {
          find_files = {
            theme = "ivy"
          }
        },
        extensions = {
          fzf = {}
        }
      }
      require('telescope').load_extension('fzf')

      vim.keymap.set("n", "<space>fh", builtin.help_tags)
      vim.keymap.set("n", "<space>fd", builtin.find_files)
      vim.keymap.set("n", "<space>en", function()
        builtin.find_files {
          cwd = vim.fn.stdpath("config")
        }
      end)
      vim.keymap.set("n", "<space>gf", builtin.git_files)
      vim.keymap.set("n", "<space>gb", builtin.git_branches)

      vim.keymap.set("n", "<space>lr", builtin.lsp_references)
      vim.keymap.set("n", "<space>ld", builtin.lsp_definitions)

      vim.keymap.set("n", "<space>ep", function()
        require("config.telescope.multigrep").live_multigrep {
          cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
        }
      end)
    end

  }
}

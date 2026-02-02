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
      vim.keymap.set("n", "<space>fk", builtin.keymaps)
      vim.keymap.set("n", "<space>fd", builtin.find_files)
      vim.keymap.set("n", "<space>en", function()
        builtin.find_files {
          cwd = vim.fn.stdpath("config")
        }
      end)
      vim.keymap.set("n", "<space>gf", builtin.git_files)
      vim.keymap.set("n", "<space>gb", builtin.git_branches)

      vim.keymap.set("n", "<space>fg", function()
        require("config.telescope.multigrep").live_multigrep()
      end, { desc = "Live multigrep" })

      -- LSP keymaps com Telescope
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('TelescopeLspKeymaps', { clear = true }),
        callback = function(args)
          local opts = { buffer = args.buf }
          vim.keymap.set('n', 'gd', builtin.lsp_definitions, opts)
          vim.keymap.set('n', 'gr', builtin.lsp_references, opts)
          vim.keymap.set('n', 'gi', builtin.lsp_implementations, opts)
          vim.keymap.set('n', 'gt', builtin.lsp_type_definitions, opts)
        end,
      })
    end

  }
}

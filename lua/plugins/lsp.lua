return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      'saghen/blink.cmp',
      {
        "folke/lazydev.nvim",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
          require("lsp_lines").setup()
        end,
      },
    },
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Desabilita virtual_text para usar lsp_lines
      vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = true,
      })

      vim.lsp.config('*', { capabilities = capabilities })

      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } },
          },
        },
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('LspKeymaps', { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          local opts = { buffer = args.buf }

          -- Navegação
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

          -- Diagnósticos
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
          vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)

          -- Ações
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)

          -- Format on save
          if client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
              end,
            })
          end
        end,
      })
    end,
  }
}

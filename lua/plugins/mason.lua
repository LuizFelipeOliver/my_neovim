return {
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      -- LSPs que serão instalados automaticamente
      ensure_installed = {
        "lua_ls",
        -- Adicione outros LSPs aqui, ex:
        -- "ts_ls",
        -- "pyright",
        -- "gopls",
      },
      -- Configura automaticamente os LSPs instalados
      automatic_enable = true,
    },
  },
}

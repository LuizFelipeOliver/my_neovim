-- Configuração de transparência para Neovim
-- Remove o fundo de todos os elementos para permitir transparência do terminal

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Fundo principal
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", ctermbg = "NONE" })

    -- Linha de números e sinais
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE", ctermbg = "NONE" })

    -- Statusline e tabline
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "TabLine", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "TabLineSel", { bg = "NONE", ctermbg = "NONE" })

    -- Menus e popups
    vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "PmenuSel", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "NONE", ctermbg = "NONE" })

    -- Folds e colunas
    vim.api.nvim_set_hl(0, "Folded", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "FoldColumn", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "ColorColumn", { bg = "NONE", ctermbg = "NONE" })

    -- Cursor line
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "CursorColumn", { bg = "NONE", ctermbg = "NONE" })

    -- Vertical split
    vim.api.nvim_set_hl(0, "VertSplit", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "WinSeparator", { bg = "NONE", ctermbg = "NONE" })

    -- End of buffer
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE", ctermbg = "NONE" })

    -- Telescope (se estiver usando)
    vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "NONE", ctermbg = "NONE" })

    -- NvimTree / Neo-tree (se estiver usando)
    vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "NONE", ctermbg = "NONE" })

    -- WhichKey
    vim.api.nvim_set_hl(0, "WhichKeyFloat", { bg = "NONE", ctermbg = "NONE" })

    -- Notify
    vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "NONE", ctermbg = "NONE" })
  end,
})

-- Aplica imediatamente ao carregar
vim.cmd("doautocmd ColorScheme")

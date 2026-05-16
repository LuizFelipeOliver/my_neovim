vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.lazy")
require("config.language")
require("config.notes")
require("config.autocomplete")
require('vim._core.ui2').enable()

vim.keymap.set("n", "<leader>vs", "<cmd>source %<CR>", { desc = "Source current file" })
vim.keymap.set("n", "<leader>vx", ":.lua<CR>", { desc = "Execute Lua line" })
vim.keymap.set("v", "<leader>vx", ":lua<CR>", { desc = "Execute Lua selection" })

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 999
vim.opt.cmdheight = 1
vim.opt.fillchars = { eob = " " }
vim.opt.list = true

local undodir = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(undodir, "p")
vim.opt.undodir = undodir
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.undoreload = 10000


vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

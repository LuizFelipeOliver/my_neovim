local set = vim.opt_local

set.shiftwidth = 4
set.tabstop = 4
set.softtabstop = 4
set.expandtab = true
set.commentstring = "// %s"

vim.keymap.set("n", "<leader>os", function()
    require("overseer").new_task({ cmd = "sail up -d", cwd = vim.fn.getcwd() }):start()
end, { buffer = true, desc = "Start Laravel project" })

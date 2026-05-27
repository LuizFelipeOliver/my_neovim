local set = vim.opt_local

set.shiftwidth = 4
set.tabstop = 4
set.softtabstop = 4
set.expandtab = false
set.commentstring = "// %s"

vim.keymap.set("n", "<leader>os", function()
    require("overseer").new_task({ cmd = "go run .", cwd = vim.fn.getcwd() }):start()
end, { buffer = true, desc = "Run Go project" })

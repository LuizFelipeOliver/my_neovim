local set = vim.opt_local

set.shiftwidth = 2
set.tabstop = 2
set.softtabstop = 2
set.commentstring = "// %s"

vim.keymap.set("n", "<leader>os", function()
    require("overseer").new_task({ cmd = "npm run dev", cwd = vim.fn.getcwd() }):start()
end, { buffer = true, desc = "Start Node project" })

local templates = {
    "builtin",
}

vim.list_extend(templates, require("config.overseer.go"))
vim.list_extend(templates, require("config.overseer.java"))

return templates

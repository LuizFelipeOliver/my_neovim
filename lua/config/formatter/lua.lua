local conform = require("conform")

conform.formatters_by_ft.lua = { "stylua" }

vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function()
        if vim.fn.executable("stylua") == 0 then
            vim.notify("[Lua] stylua not found. Run :MasonInstall stylua", vim.log.levels.WARN)
        end
    end,
    once = true,
})

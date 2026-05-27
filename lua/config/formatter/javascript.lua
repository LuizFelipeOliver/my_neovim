local conform = require("conform")

conform.formatters_by_ft.javascript = { "prettier" }
conform.formatters_by_ft.typescript = { "prettier" }
conform.formatters_by_ft.tsx = { "prettier" }
conform.formatters_by_ft.json = { "prettier" }
conform.formatters_by_ft.css = { "prettier" }
conform.formatters_by_ft.html = { "prettier" }

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "typescript", "tsx", "json", "css", "html" },
    callback = function()
        if vim.fn.executable("prettier") == 0 then
            vim.notify("[JS/TS] prettier not found. Run :MasonInstall prettier", vim.log.levels.WARN)
        end
    end,
    once = true,
})

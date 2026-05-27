local lint = require("lint")

lint.linters_by_ft.javascript = { "eslint" }
lint.linters_by_ft.typescript = { "eslint" }

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "typescript" },
    callback = function()
        if vim.fn.executable("eslint") == 0 then
            vim.notify("[JS/TS] eslint not found. Run :MasonInstall eslint", vim.log.levels.WARN)
            return
        end
        lint.try_lint("eslint")
    end,
})

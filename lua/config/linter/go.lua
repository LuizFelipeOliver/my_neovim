local lint = require("lint")

lint.linters_by_ft.go = { "golangcilint" }

vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        if vim.fn.executable("golangci-lint") == 0 then
            vim.notify("[Go] golangci-lint not found. Run :MasonInstall golangci-lint", vim.log.levels.WARN)
            return
        end
        lint.try_lint("golangcilint")
    end,
})

local lint = require("lint")

lint.linters_by_ft.php = { "phpstan" }

vim.api.nvim_create_autocmd("FileType", {
    pattern = "php",
    callback = function()
        if vim.fn.executable("phpstan") == 0 then
            vim.notify("[PHP] phpstan not found. Run :MasonInstall phpstan", vim.log.levels.WARN)
            return
        end
        lint.try_lint("phpstan")
    end,
})

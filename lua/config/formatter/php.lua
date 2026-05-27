local conform = require("conform")

conform.formatters_by_ft.php = { "pint" }
conform.formatters_by_ft.blade = { "blade-formatter" }

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "php", "blade" },
    callback = function()
        local tools = { "pint", "blade-formatter" }
        for _, tool in ipairs(tools) do
            if vim.fn.executable(tool) == 0 then
                vim.notify("[PHP] " .. tool .. " not found. Run :MasonInstall " .. tool, vim.log.levels.WARN)
                break
            end
        end
    end,
    once = true,
})

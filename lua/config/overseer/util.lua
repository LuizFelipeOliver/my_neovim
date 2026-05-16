local M = {}

function M.root_pattern(...)
    local markers = { ... }

    return function()
        return vim.fs.root(0, markers)
    end
end

function M.has_root(...)
    local find_root = M.root_pattern(...)

    return function()
        return find_root() ~= nil
    end
end

function M.current_file_dir()
    local file = vim.api.nvim_buf_get_name(0)

    if file == "" then
        return vim.uv.cwd()
    end

    return vim.fs.dirname(file)
end

return M

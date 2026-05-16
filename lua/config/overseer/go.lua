local util = require("config.overseer.util")

return {
    {
        name = "go test ./...",
        builder = function()
            return {
                cmd = { "go" },
                args = { "test", "./..." },
                cwd = util.root_pattern("go.mod")(),
                components = { "default" },
            }
        end,
        condition = {
            callback = util.has_root("go.mod"),
        },
    },
    {
        name = "go test current package",
        builder = function()
            return {
                cmd = { "go" },
                args = { "test", "." },
                cwd = util.current_file_dir(),
                components = { "default" },
            }
        end,
        condition = {
            filetype = { "go" },
            callback = util.has_root("go.mod"),
        },
    },
    {
        name = "go run .",
        builder = function()
            return {
                cmd = { "go" },
                args = { "run", "." },
                cwd = util.root_pattern("go.mod")(),
                components = { "default" },
            }
        end,
        condition = {
            callback = util.has_root("go.mod"),
        },
    },
    {
        name = "go build ./...",
        builder = function()
            return {
                cmd = { "go" },
                args = { "build", "./..." },
                cwd = util.root_pattern("go.mod")(),
                components = { "default" },
            }
        end,
        condition = {
            callback = util.has_root("go.mod"),
        },
    },
}

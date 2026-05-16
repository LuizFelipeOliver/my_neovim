local util = require("config.overseer.util")

local gradle_markers = {
    "settings.gradle",
    "settings.gradle.kts",
    "build.gradle",
    "build.gradle.kts",
}

local function gradle_root()
    return util.root_pattern(unpack(gradle_markers))()
end

local function gradle_cmd(root)
    local gradlew = root and (root .. "/gradlew") or "gradle"

    if vim.fn.executable(gradlew) == 1 then
        return gradlew
    end

    return "gradle"
end

return {
    {
        name = "maven test",
        builder = function()
            return {
                cmd = { "mvn" },
                args = { "test" },
                cwd = util.root_pattern("pom.xml")(),
                components = { "default" },
            }
        end,
        condition = {
            callback = util.has_root("pom.xml"),
        },
    },
    {
        name = "maven package",
        builder = function()
            return {
                cmd = { "mvn" },
                args = { "package" },
                cwd = util.root_pattern("pom.xml")(),
                components = { "default" },
            }
        end,
        condition = {
            callback = util.has_root("pom.xml"),
        },
    },
    {
        name = "gradle test",
        builder = function()
            local root = gradle_root()

            return {
                cmd = { gradle_cmd(root) },
                args = { "test" },
                cwd = root,
                components = { "default" },
            }
        end,
        condition = {
            callback = util.has_root(unpack(gradle_markers)),
        },
    },
    {
        name = "gradle build",
        builder = function()
            local root = gradle_root()

            return {
                cmd = { gradle_cmd(root) },
                args = { "build" },
                cwd = root,
                components = { "default" },
            }
        end,
        condition = {
            callback = util.has_root(unpack(gradle_markers)),
        },
    },
}

return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            {
                "fredrikaverpil/neotest-golang",
                version = "*", -- Optional, but recommended; track releases
                build = function()
                    local result = vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait()
                    if result.code ~= 0 then
                        error("Falha ao instalar gotestsum: " .. (result.stderr or "erro desconhecido"))
                    end
                end,
            },
        },
        config = function()
            local function test_file_for_current_buffer()
                local current_file = vim.fn.expand("%:p")

                if current_file:match("_test%.go$") then
                    return current_file
                end

                if current_file:match("%.go$") then
                    local test_file = current_file:gsub("%.go$", "_test.go")

                    if vim.fn.filereadable(test_file) == 1 then
                        return test_file
                    end
                end

                return current_file
            end

            require("neotest").setup({
                adapters = {
                    require("neotest-golang")({
                        runner = "gotestsum",
                        dap_mode = "manual",
                        dap_manual_config = function()
                            return {
                                type = "delve",
                                name = "Debug nearest Go test",
                                request = "launch",
                                mode = "test",
                            }
                        end,
                    }),
                },
            })

            vim.keymap.set("n", "<leader>tr", function()
                require("neotest").run.run()
            end, { desc = "Run nearest test" })

            vim.keymap.set("n", "<leader>tf", function()
                require("neotest").run.run(test_file_for_current_buffer())
            end, { desc = "Run file tests" })

            vim.keymap.set("n", "<leader>ta", function()
                require("neotest").run.run(vim.uv.cwd())
            end, { desc = "Run all tests" })

            vim.keymap.set("n", "<leader>td", function()
                require("neotest").run.run({ suite = false, strategy = "dap" })
            end, { desc = "Debug nearest test" })

            vim.keymap.set("n", "<leader>tD", function()
                require("neotest").run.run({ test_file_for_current_buffer(), strategy = "dap" })
            end, { desc = "Debug file tests" })

            vim.keymap.set("n", "<leader>ts", function()
                require("neotest").summary.toggle()
            end, { desc = "Toggle test summary" })

            vim.keymap.set("n", "<leader>to", function()
                require("neotest").output.open()
            end, { desc = "Open test output" })
        end,
    },
}

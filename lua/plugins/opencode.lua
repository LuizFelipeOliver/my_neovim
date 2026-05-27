return {
    "sudo-tee/opencode.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "MeanderingProgrammer/render-markdown.nvim",
            opts = {
                file_types = { "markdown", "opencode_output" },
            },
            ft = { "markdown", "opencode_output" },
        },
    },
    config = function()
        require("opencode").setup({
            default_global_keymaps = false,
            default_mode = "build",
            ui = {
                position = "right",
                window_width = 0.40,
                input_position = "bottom",
            },
            context = {
                enabled = true,
                current_file = { enabled = true },
                selection = { enabled = true },
                diagnostics = { error = true, warning = true },
            },
            keymap = {
                editor = {
                    ["<C-/>"] = { "toggle_focus" },
                    ["<C-\\>"] = { "open_input" },
                    ["<C-e>"] = {
                        function()
                            require("opencode.api").add_visual_selection()
                            require("opencode.api").run("Explain this code")
                        end,
                        mode = { "x" },
                        desc = "Explain selection",
                    },
                    ["<C-z>"] = {
                        function()
                            require("opencode.api").run("I'm stuck. Help me continue this code based on what's already here.")
                        end,
                        mode = { "n" },
                        desc = "I'm stuck",
                    },
                },
            },
        })
    end,
}

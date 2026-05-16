return {
    'saghen/blink.cmp',
    dependencies = {
        'saghen/blink.lib',
        'echasnovski/mini.nvim',
        'Exafunction/windsurf.nvim',
    },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = { preset = 'default' },

        snippets = { preset = 'mini_snippets' },

        completion = {
            -- Only show the documentation popup when manually triggered
            documentation = { auto_show = false },
            ghost_text = { enabled = false },
        },

        -- (Default) list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer', 'codeium' },
            providers = {
                codeium = {
                    name = 'Windsurf',
                    module = 'codeium.blink',
                    async = true,
                },
            },
        },

        -- Use the Lua matcher to avoid needing the Rust binary/build step.
        fuzzy = { implementation = "lua" }
    },
}

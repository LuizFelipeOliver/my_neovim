return {
  {
    "Exafunction/windsurf.nvim",
    event = "InsertEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("codeium").setup({
        enable_cmp_source = false,
        virtual_text = {
          enabled = true,
          manual = false,
          key_bindings = {
            accept = "<Tab>",
            accept_word = false,
            accept_line = false,
            clear = "<M-c>",
            next = "<M-]>",
            prev = "<M-[>",
          },
        },
      })
    end,
  },
}

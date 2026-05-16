return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "jay-babu/mason-nvim-dap.nvim",
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end,                         desc = "Toggle Breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,                                  desc = "Continue" },
      { "<leader>di", function() require("dap").step_into() end,                                 desc = "Step Into" },
      { "<leader>do", function() require("dap").step_over() end,                                 desc = "Step Over" },
      { "<leader>dO", function() require("dap").step_out() end,                                  desc = "Step Out" },
      { "<leader>dr", function() require("dap").repl.toggle() end,                               desc = "Toggle REPL" },
      { "<leader>dl", function() require("dap").run_last() end,                                  desc = "Run Last" },
      { "<leader>dt", function() require("dap").terminate() end,                                 desc = "Terminate" },
      { "<leader>du", function() require("dapui").toggle() end,                                  desc = "Toggle DAP UI" },
      { "<leader>de", function() require("dapui").eval() end,                                    desc = "Eval",                  mode = { "n", "v" } },
    },
    config = function()
      require("dapui").setup()
      require("nvim-dap-virtual-text").setup()
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "delve",
      },
      automatic_installation = true,
      handlers = {},
    },
  },
}

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
      { "<space>db", function() require("dap").toggle_breakpoint() end,                         desc = "Toggle Breakpoint" },
      { "<space>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional Breakpoint" },
      { "<space>dc", function() require("dap").continue() end,                                  desc = "Continue" },
      { "<space>di", function() require("dap").step_into() end,                                 desc = "Step Into" },
      { "<space>do", function() require("dap").step_over() end,                                 desc = "Step Over" },
      { "<space>dO", function() require("dap").step_out() end,                                  desc = "Step Out" },
      { "<space>dr", function() require("dap").repl.toggle() end,                               desc = "Toggle REPL" },
      { "<space>dl", function() require("dap").run_last() end,                                  desc = "Run Last" },
      { "<space>dt", function() require("dap").terminate() end,                                 desc = "Terminate" },
      { "<space>du", function() require("dapui").toggle() end,                                  desc = "Toggle DAP UI" },
      { "<space>de", function() require("dapui").eval() end,                                    desc = "Eval",                  mode = { "n", "v" } },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Setup DAP UI
      dapui.setup()

      -- Setup virtual text
      require("nvim-dap-virtual-text").setup()

      -- Abre/fecha DAP UI automaticamente + notificações
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
        vim.notify("Debug iniciado", vim.log.levels.INFO, { title = "DAP" })
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
        vim.notify("Debug terminado", vim.log.levels.WARN, { title = "DAP" })
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
        vim.notify("Debug encerrado", vim.log.levels.WARN, { title = "DAP" })
      end

      -- Ícones para breakpoints
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition",
        { text = "◐", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      -- Instala automaticamente os debuggers quando necessário
      automatic_installation = true,
      -- Configura automaticamente os adaptadores instalados
      handlers = {},
      -- Debuggers para garantir instalação (opcional)
      -- ensure_installed = { "python", "codelldb", "js", "delve" },
    },
  },
}

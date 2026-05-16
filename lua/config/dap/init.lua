local M = {}

function M.setup()
  local dap = require("dap")
  local dapui = require("dapui")

  dapui.setup()
  require("nvim-dap-virtual-text").setup()

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
    vim.notify("Debug started", vim.log.levels.INFO, { title = "DAP" })
  end

  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
    vim.notify("Debug terminated", vim.log.levels.WARN, { title = "DAP" })
  end

  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
    vim.notify("Debug exited", vim.log.levels.WARN, { title = "DAP" })
  end

  vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
  vim.fn.sign_define("DapBreakpointCondition", { text = "◐", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
  vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })

  require("config.dap.go").setup(dap)
end

return M

local M = {}

local filetypes = {
  "javascript",
  "typescript",
  "javascriptreact",
  "typescriptreact",
}

function M.setup(dap)
  local js_debug = vim.fn.exepath("js-debug-adapter")

  if js_debug == "" then
    return
  end

  dap.adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = js_debug,
      args = { "${port}" },
    },
  }

  local configurations = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch current file",
      program = "${file}",
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      console = "integratedTerminal",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach to process",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
      sourceMaps = true,
    },
  }

  for _, filetype in ipairs(filetypes) do
    dap.configurations[filetype] = configurations
  end
end

return M

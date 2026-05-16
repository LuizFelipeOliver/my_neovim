local M = {}

local function mason_bin(name)
  return vim.fn.stdpath("data") .. "/mason/bin/" .. name
end

function M.setup(dap)
  local dlv = vim.fn.exepath("dlv")

  if dlv == "" and vim.fn.executable(mason_bin("dlv")) == 1 then
    dlv = mason_bin("dlv")
  end

  if dlv == "" then
    return
  end

  dap.adapters.delve = {
    type = "server",
    port = "${port}",
    executable = {
      command = dlv,
      args = { "dap", "-l", "127.0.0.1:${port}" },
    },
  }

  dap.configurations.go = {
    {
      type = "delve",
      name = "Debug package",
      request = "launch",
      program = "${workspaceFolder}",
    },
    {
      type = "delve",
      name = "Debug file",
      request = "launch",
      program = "${file}",
    },
    {
      type = "delve",
      name = "Debug test file",
      request = "launch",
      mode = "test",
      program = "${file}",
    },
    {
      type = "delve",
      name = "Debug package tests",
      request = "launch",
      mode = "test",
      program = "${fileDirname}",
    },
  }
end

return M

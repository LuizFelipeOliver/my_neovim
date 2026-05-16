local M = {}

function M.setup(dap)
  local php_debug = vim.fn.exepath("php-debug-adapter")

  if php_debug == "" then
    return
  end

  dap.adapters.php = {
    type = "executable",
    command = php_debug,
  }

  dap.configurations.php = {
    {
      type = "php",
      request = "launch",
      name = "Listen for Xdebug",
      port = 9003,
      pathMappings = {
        ["/var/www/html"] = "${workspaceFolder}",
      },
    },
  }
end

return M

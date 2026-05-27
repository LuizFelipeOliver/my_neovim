local dap = require("dap")

dap.configurations.php = {
    {
        type = "php",
        name = "Listen for Xdebug",
        request = "launch",
        port = 9003,
        pathMappings = {
            ["/var/www/html"] = vim.fn.getcwd(),
        },
    },
}

dap.adapters.php = {
    type = "executable",
    command = "node",
    args = { vim.fn.stdpath("data") .. "/mason/bin/php-debug-adapter" },
}

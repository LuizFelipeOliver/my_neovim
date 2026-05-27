local dap = require("dap")

dap.configurations.javascript = {
    {
        type = "pwa-node",
        name = "Launch file",
        request = "launch",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        runtimeExecutable = "node",
    },
}

dap.configurations.typescript = {
    {
        type = "pwa-node",
        name = "Launch file",
        request = "launch",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        runtimeExecutable = "node",
    },
}

dap.adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
        command = "node",
        args = {
            vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter",
            "${port}",
        },
    },
}

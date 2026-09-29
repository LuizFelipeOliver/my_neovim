local dap = require("dap")

local configurations = {
	{
		type = "codelldb",
		name = "Launch",
		request = "launch",
		program = function()
			return vim.fn.input("Caminho do executável: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}

dap.configurations.cpp = configurations
dap.configurations.c = configurations

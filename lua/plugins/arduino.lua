return {
	"yuukiflow/Arduino-Nvim",
	ft = "arduino",
	opts = {},
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	init = function()
		vim.filetype.add({ extension = { ino = "arduino" } })
	end,
}

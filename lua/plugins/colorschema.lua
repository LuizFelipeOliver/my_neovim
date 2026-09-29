return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function(_, opts)
		require("tokyonight").setup(opts)
		vim.cmd([[colorscheme tokyonight-night]])
	end,
}

-- return {
-- 	"ellisonleao/gruvbox.nvim",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		vim.o.background = "dark"
-- 		vim.cmd([[colorscheme gruvbox]])
-- 	end,
-- }

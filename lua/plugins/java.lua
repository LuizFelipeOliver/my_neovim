local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

return {
	"nvim-java/nvim-java",
	lazy = false,
	dependencies = {
		"MunifTanjim/nui.nvim",
		"mfussenegger/nvim-dap",
		{
			"JavaHello/spring-boot.nvim",
			commit = "218c0c26c14d99feca778e4d13f5ec3e8b1b60f0",
		},
	},
	config = function()
		vim.env.JAVA_HOME = "/usr/lib/jvm/java-27-openjdk"

		require("java").setup({
			jdtls = {
				path = jdtls_path,
				auto_install = false,
			},
			lombok = {
				path = jdtls_path .. "/lombok.jar",
				auto_install = false,
			},
			jdk = {
				path = "/usr/lib/jvm/java-27-openjdk",
				auto_install = false,
			},
		})

		vim.lsp.enable("jdtls")
	end,
}

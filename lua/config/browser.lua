local function search_browser(query)
	query = vim.trim(query:gsub("%s+", " "))
	if query == "" then
		vim.notify("No text to search", vim.log.levels.WARN)
		return
	end

	vim.ui.open("https://www.google.com/search?q=" .. vim.uri_encode(query))
end

vim.api.nvim_create_user_command("BrowserSearch", function(args)
	local query = args.args ~= "" and args.args or vim.fn.expand("<cword>")
	search_browser(query)
end, {
	nargs = "*",
	desc = "Search text in the browser",
})

vim.keymap.set("n", "<M-k>", function()
	search_browser(vim.fn.expand("<cword>"))
end, { desc = "Search word in browser" })

vim.keymap.set("x", "<M-k>", function()
	local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), {
		type = vim.fn.mode(),
	})
	search_browser(table.concat(lines, " "))
end, { desc = "Search selection in browser" })

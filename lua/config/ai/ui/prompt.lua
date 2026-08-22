local M = {}
local window

local function close()
	if window and vim.api.nvim_win_is_valid(window) then
		vim.api.nvim_win_close(window, true)
	end
	window = nil
end

function M.open(mode, on_submit)
	if window and vim.api.nvim_win_is_valid(window) then
		vim.api.nvim_set_current_win(window)
		return
	end

	local buffer = vim.api.nvim_create_buf(false, true)
	vim.bo[buffer].buftype = "nofile"
	vim.bo[buffer].bufhidden = "wipe"
	vim.bo[buffer].swapfile = false
	vim.bo[buffer].filetype = "markdown"

	local width = math.min(vim.o.columns - 4, 100)
	window = vim.api.nvim_open_win(buffer, true, {
		relative = "editor",
		anchor = "SW",
		width = width,
		height = 5,
		row = vim.o.lines - 2,
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
		title = " AI " .. mode:gsub("^%l", string.upper) .. " ",
		title_pos = "center",
	})

	local function submit()
		local prompt = table.concat(vim.api.nvim_buf_get_lines(buffer, 0, -1, false), "\n")
		close()
		if prompt ~= "" then
			on_submit(prompt)
		end
	end

	vim.keymap.set({ "i", "n" }, "<CR>", submit, { buffer = buffer, silent = true })
	vim.keymap.set({ "i", "n" }, "<Esc>", close, { buffer = buffer, silent = true })
	vim.cmd("startinsert")
end

return M

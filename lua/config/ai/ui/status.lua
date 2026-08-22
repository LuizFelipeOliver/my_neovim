local M = {}
local window

function M.toggle(status)
	if window and vim.api.nvim_win_is_valid(window) then
		vim.api.nvim_win_close(window, true)
		return
	end

	local lines = {}
	local highlights = {}
	local function add_line(prefix, value, highlight)
		table.insert(lines, prefix .. value)
		table.insert(highlights, { highlight, #lines - 1, #prefix, -1 })
	end

	add_line("󰚩 Provider: ", status.provider, "DiagnosticInfo")
	add_line("  Model: ", status.model or "not selected", "DiagnosticHint")
	add_line("  Variant: ", status.variant or "not selected", "DiagnosticWarn")
	if status.mode then
		add_line("  Mode: ", status.mode:gsub("^%l", string.upper), "DiagnosticInfo")
	end
	if status.error_message then
		add_line("  Error: ", status.error_message, "DiagnosticError")
	end

	local width = 0
	for _, line in ipairs(lines) do
		width = math.max(width, vim.fn.strdisplaywidth(line))
	end

	local buffer = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
	for _, highlight in ipairs(highlights) do
		vim.api.nvim_buf_add_highlight(buffer, 0, unpack(highlight))
	end
	vim.bo[buffer].bufhidden = "wipe"
	vim.bo[buffer].modifiable = false

	local window_width = width + 2
	local window_height = #lines
	window = vim.api.nvim_open_win(buffer, false, {
		relative = "editor",
		anchor = "SE",
		width = window_width,
		height = window_height,
		row = vim.o.lines - 2,
		col = vim.o.columns - 1,
		style = "minimal",
		focusable = false,
		border = "rounded",
		title = " AI Provider ",
		title_pos = "center",
	})
	vim.wo[window].winhighlight = "FloatBorder:DiagnosticInfo,FloatTitle:DiagnosticInfo"
end

return M

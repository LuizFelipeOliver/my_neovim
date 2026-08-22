local M = {}
local buffers = {}
local window

local function get_buffer(kind)
	local buffer = buffers[kind]
	if buffer and vim.api.nvim_buf_is_valid(buffer) then
		return buffer
	end

	buffer = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(buffer, "AI " .. kind:gsub("^%l", string.upper))
	vim.bo[buffer].buftype = "nofile"
	vim.bo[buffer].bufhidden = "hide"
	vim.bo[buffer].swapfile = false
	buffers[kind] = buffer
	return buffer
end

function M.start(kind)
	local buffer = get_buffer(kind)
	vim.bo[buffer].modifiable = true
	vim.api.nvim_buf_set_lines(buffer, 0, -1, false, {})
	vim.bo[buffer].modifiable = false

	if not window or not vim.api.nvim_win_is_valid(window) then
		local current_window = vim.api.nvim_get_current_win()
		vim.cmd("botright vsplit")
		window = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_width(window, math.floor(vim.o.columns * 0.45))
		vim.api.nvim_set_current_win(current_window)
	end

	vim.api.nvim_win_set_buf(window, buffer)
	vim.bo[buffer].filetype = "markdown"
end

function M.append(kind, text)
	if type(text) ~= "string" or text == "" then
		return
	end

	local buffer = get_buffer(kind)
	local lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)
	local chunks = vim.split(text, "\n", { plain = true })
	if #lines == 0 then
		lines = { "" }
	end

	lines[#lines] = lines[#lines] .. chunks[1]
	for index = 2, #chunks do
		table.insert(lines, chunks[index])
	end

	vim.bo[buffer].modifiable = true
	vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
	vim.bo[buffer].modifiable = false
	if window and vim.api.nvim_win_is_valid(window) and vim.api.nvim_win_get_buf(window) == buffer then
		vim.api.nvim_win_set_cursor(window, { #lines, 0 })
	end
end

function M.complete(kind, result)
	local reason = result and result.stopReason or "complete"
	M.append(kind, "\n\n[" .. reason .. "]\n")
end

function M.error(kind, message)
	M.append(kind, "\n\n[error] " .. message .. "\n")
end

return M

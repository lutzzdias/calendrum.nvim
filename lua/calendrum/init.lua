local M = {}
local date_helper = require("calendrum.date")

local function create_v_split()
	local current_window = 0
	local window_width = 24
	vim.cmd("vsplit new")
	vim.api.nvim_win_set_width(current_window, window_width)
	local window = vim.api.nvim_get_current_win()
	local buffer = vim.api.nvim_create_buf(true, true)
	vim.api.nvim_win_set_buf(window, buffer)
	return vim.api.nvim_get_current_buf()
end

local function write_month(buf, month)
	for i = 1, #month do
		local line = i - 1
		local line_data = { table.concat(month[i], " ") }
		vim.api.nvim_buf_set_lines(buf, line, line, 0, line_data)
	end
end

M.setup = function(opts)
	opts = opts or {}
	local date = os.date("*t")

	local buf = create_v_split()
	local calendar = date_helper.build_month(date.year, date.month)

	write_month(buf, calendar)
end

M.setup()

return M

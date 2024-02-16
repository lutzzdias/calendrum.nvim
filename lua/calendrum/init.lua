local M = {}
local date_helper = require("calendrum.date")

local function create_v_split()
	local current_window = 0
	local window_width = 22
	vim.cmd("vsplit new")
	vim.api.nvim_win_set_width(current_window, window_width)
	local window = vim.api.nvim_get_current_win()
	local buffer = vim.api.nvim_create_buf(true, true)
	vim.api.nvim_win_set_buf(window, buffer)
end

M.setup = function(opts)
	opts = opts or {}
	local date = os.date("*t")
	date_helper.build_month(date.year, date.month)
end

M.setup()

return M

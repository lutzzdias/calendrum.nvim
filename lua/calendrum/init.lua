local Window = require("calendrum.view.window")
local Calendar = require("calendrum.calendar")
local Util = require("calendrum.util")

local M = {}

M.setup = function(opts)
	local ns = vim.api.nvim_create_namespace("calendrum")
	Util.highlight.define_highlights(ns)

	opts = opts or {}

	local win = Window:new()
	win:open()

	local year = Util.date.get_current_year()
	local month = Util.date.get_current_month()

	local cal = Calendar.generate_month(year, month)
	win:insert(cal)

	-- Example: Apply highlight to the first line
	vim.api.nvim_buf_add_highlight(win.buf_id, ns, "@comment", 0, 0, math.floor(vim.api.nvim_win_get_width(0) * 0.5))
end

M.setup()

return M

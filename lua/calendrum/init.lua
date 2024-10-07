local Window = require("calendrum.view.window")
local Calendar = require("calendrum.calendar")
local Util = require("calendrum.util")

local M = {}

M.setup = function(opts)
	Util.highlight.define_highlights()

	opts = opts or {}

	local win = Window:new()
	win:open()

	local year = Util.date.get_current_year()
	local month = Util.date.get_current_month()

	local cal = Calendar.generate_month(year, month)
	win:insert(cal)

	-- Example: Apply highlight to the first line
	vim.api.nvim_buf_add_highlight(win.buf_id, 0, "CalendrumToday", 0, 0, -1)
end

M.setup()

return M

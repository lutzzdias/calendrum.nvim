local Calendar = require("calendrum.calendar")
local Config = require("calendrum.config")
local Window = require("calendrum.view.window")

local M = {}

M.setup = function(opts)
	opts = opts or {}

	Config.setup(opts)
end

---@param year? number
---@param month? number
M.show = function(year, month)
	M.win = Window
	M.calendar = Calendar
	local c = M.calendar:generate_month(year, month)

	M.win:open()
	M.win:render_month(c)
end

M.register_highlight = function(condition, highlight)
	M.calendar:register_condition(condition, highlight)
end

M.register_action = function(keymap, callback)
	local date = {
		year = M.calendar.year,
		month = M.calendar.month,
		day = M.win.get_date_from_cursor(M.calendar.year, M.calendar.month),
	}
	M.win:register_action(keymap, callback, date)
end

return M

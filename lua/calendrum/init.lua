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

-- TODO: Allow for this function to run with no active window
M.register_action = function(keymap, callback)
	M.win:register_action(keymap, callback)
end

return M

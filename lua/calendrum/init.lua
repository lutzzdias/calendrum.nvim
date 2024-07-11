local Window = require("calendrum.view.window")
local Calendar = require("calendrum.calendar")

local M = {}

M.setup = function(opts)
	opts = opts or {}

	local win = Window:new()
	win:open()
	local cal = Calendar.generate_calendar()
	win:insert(cal)
end

M.setup()

return M

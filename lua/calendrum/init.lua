local Window = require("calendrum.view.window")
local Calendar = require("calendrum.calendar")
local Util = require("calendrum.util")

local M = {}

M.setup = function(opts)
	Util.highlight.define_highlights()

	opts = opts or {}

	M.win = Window:new()
	M.win:open()

	M.year = Util.date.get_current_year()
	M.month = Util.date.get_current_month()

	local cal = Calendar:new()
	local month = cal:generate_month(M.year, M.month)
	M.win:render_month(month)
end

-- TODO: Move to better fitting place
M.next_month = function()
	M.month = M.month + 1
	if M.month > 12 then
		M.month = 1
		M.year = M.year + 1
	end

	local cal = Calendar.generate_month(M.year, M.month)
	M.win:insert(cal)
end

-- TODO: Move to better fitting place
M.prev_month = function()
	M.month = M.month - 1
	if M.month < 1 then
		M.month = 12
		M.year = M.year - 1
	end

	local cal = Calendar.generate_month(M.year, M.month)
	M.win:insert(cal)
end

M.setup()

return M

local Window = require("calendrum.view.window")
local Calendar = require("calendrum.calendar")
local Util = require("calendrum.util")

local M = {}

M.setup = function(opts)
	Util.highlight.define_highlights()

	opts = opts or {}

	M.win = Window:new()
	M.win:open()

	local cal = Calendar:new()
	local month = cal:generate_month()
	M.win:render_month(month)

end

M.setup()

return M

local View = require("calendrum.view")
local Calendar = require("calendrum.calendar")

local M = {}

M.setup = function(opts)
	opts = opts or {}

	local v = View.new()
	local c = Calendar.new()

	v:create()
	c:render_month(v)
	v:render()
end

M.setup()

return M

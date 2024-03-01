local View = require("calendrum.view")
local Calendar = require("calendrum.calendar")

local M = {}

M.setup = function(opts)
	opts = opts or {}

	local v = View.new()
	local c = Calendar.new()

	for _, d in ipairs(c.month.days) do
		v.text:append(d.date, d.highlight)
	end

	v:create()
	v:render()
end

M.setup()

return M

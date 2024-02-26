local Date = require("calendrum.date")
local View = require("calendrum.view")

local M = {}

M.setup = function(opts)
	opts = opts or {}
	local now = os.date("*t")
	local current_month = Date.build_month(now.year, now.month)

	local v = View.new()

	for _, week in ipairs(current_month) do
		v.text:append(week)
	end

	v:create()
	print(vim.inspect(v))
end

M.setup()

return M

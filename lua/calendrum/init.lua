local Date = require("calendrum.date")
local View = require("calendrum.view")

local M = {}

M.setup = function(opts)
	opts = opts or {}
	local now = os.date("*t")
	local current_month = Date.build_month(now.year, now.month)
	local week_days = table.concat(current_month[1], " ")

	local v = View.new()

	v.text:append(week_days)

	v:create()
	print(vim.inspect(v))
end

M.setup()

return M

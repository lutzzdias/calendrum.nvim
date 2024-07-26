local Util = require("calendrum.util")

local M = {}
M.__index = M

function M.generate_header()
	return "Su Mo Tu We Th Fr Sa"
end

function M.generate_month(y, m)
	local days_in_month = Util.date.get_number_of_days(y, m)
	local starting_weekday = Util.date.get_starting_weekday(y, m)

	local header = M.generate_header()

	local month = {}
	local week = {}

	for _ = 1, starting_weekday do
		table.insert(week, "  ")
	end

	for day = 1, days_in_month do
		table.insert(week, string.format("%2d", day))
		if #week == 7 then
			table.insert(month, table.concat(week, " "))
			week = {}
		end
	end

	if #week > 0 then
		table.insert(month, table.concat(week, " "))
	end

	table.insert(month, 1, header)

	return month
end

return M

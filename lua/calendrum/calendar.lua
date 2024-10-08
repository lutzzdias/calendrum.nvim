local Util = require("calendrum.util")

local M = {}
M.__index = M

function M.generate_header()
	return {
		{ value = "Su", highlight = "CalendrumHeader" },
		{ value = "Mo", highlight = "CalendrumHeader" },
		{ value = "Tu", highlight = "CalendrumHeader" },
		{ value = "We", highlight = "CalendrumHeader" },
		{ value = "Th", highlight = "CalendrumHeader" },
		{ value = "Fr", highlight = "CalendrumHeader" },
		{ value = "Sa", highlight = "CalendrumHeader" },
	}
end

function M.generate_month(y, m)
	local days_in_month = Util.date.get_number_of_days(y, m)
	local starting_weekday = Util.date.get_starting_weekday(y, m)

	local header = M.generate_header()

	local month = {}
	local week = {}
	local today = os.date("*t")
	local is_today = function(day)
		return day == today.day and tonumber(m) == today.month and tonumber(y) == today.year
	end
	local is_weekend = function(day)
		local t = os.time({ year = y, month = m, day = day })
		local weekday = os.date("*t", t).wday
		return weekday == 7 or weekday == 1
	end

	for _ = 1, starting_weekday do
		local day = {
			value = "  ",
			highlight = "",
		}
		table.insert(week, day)
	end

	for day = 1, days_in_month do
		local day_object = {
			value = string.format("%2d", day),
			highlight = (is_today(day) and "CalendrumToday") or (is_weekend(day) and "CalendrumWeekend") or "",
		}
		table.insert(week, day_object)

		if #week == 7 then
			table.insert(month, week)
			week = {}
		end
	end

	if #week > 0 then
		table.insert(month, week)
	end

	table.insert(month, 1, header)

	return month
end

return M

--- @class Date
local M = {}
M.__index = M

function M.new()
	-- create new instance with default values
	local instance = {}

	-- anything not found on instance will be looked up in M, including functions
	setmetatable(instance, M)

	return instance
end

M.week_days = {
	{ name = "Sunday", abbreviation = "S" },
	{ name = "Monday", abbreviation = "M" },
	{ name = "Tuesday", abbreviation = "T" },
	{ name = "Wednesday", abbreviation = "W" },
	{ name = "Thursday", abbreviation = "T" },
	{ name = "Friday", abbreviation = "F" },
	{ name = "Saturday", abbreviation = "S" },
}

--- @param year number
--- @return boolean
M.is_leap_year = function(year)
	-- if year is divisible by 4 it is a leap year (with exceptions)
	-- exceptions: if year is divisible by 100 and by 400 it is a leap year
	return (year % 4 == 0) and not (year % 100 == 0) or (year % 400 == 0)
end

--- returns the first day of a given month
--
--- @param year number
--- @param month number
--- @return osdate | string
M.get_first_day = function(year, month)
	local time = os.time({ year = year, month = month, day = 1 })
	return os.date("*t", time)
end

--- returns the last day of the previous month of a given month
--
--- @param year number
--- @param month number
--- @return osdate | string
M.get_last_day = function(year, month)
	local next_month_year = year
	local next_month = month + 1

	if next_month > 12 then
		next_month_year = year + 1
		next_month = 1
	end

	-- time = last day of the month
	local time = os.time({ year = next_month_year, month = next_month, day = 0 })
	return os.date("*t", time)
end

--- @param year number
--- @param month number
--- @return string[]
M.build_month = function(year, month)
	local calendar = {}
	local empty_cell = "  "
	local day = 1

	local first_day = M.get_first_day(year, month).wday
	local last_day = M.get_last_day(year, month).day

	-- insert week days abbreviations
	local week_days = ""
	for i = 1, 7 do
		week_days = week_days .. " " .. M.week_days[i].abbreviation .. " "
	end
	calendar[1] = week_days

	-- insert days
	for i = 2, 7 do
		local week = {}
		for j = 1, 7 do
			-- empty -> first week and before start of current month
			if i == 2 and j < first_day then
				week[j] = empty_cell

			-- always 2 digits
			elseif day <= last_day then
				week[j] = string.format("%2d", day)
				day = day + 1
			end
		end

		calendar[i] = table.concat(week, " ")

		if day > last_day then
			break
		end
	end

	return calendar
end

return M

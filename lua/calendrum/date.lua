local M = {}

M.week_days = {
	{
		name = "Sunday",
		abbreviation = "S",
	},
	{
		name = "Monday",
		abbreviation = "M",
	},
	{
		name = "Tuesday",
		abbreviation = "T",
	},
	{
		name = "Wednesday",
		abbreviation = "W",
	},
	{
		name = "Thursday",
		abbreviation = "T",
	},
	{
		name = "Friday",
		abbreviation = "F",
	},
	{
		name = "Saturday",
		abbreviation = "S",
	},
}

function M.is_leap_year(year)
	-- if year is divisible by 4 it is a leap year (with exceptions)
	-- exceptions: if year is divisible by 100 and by 400 it is a leap year
	return (year % 4 == 0) and not (year % 100 == 0) or (year % 400 == 0)
end

function M.get_first_day(year, month)
	-- time = first day of the month
	local time = os.time({ year = year, month = month, day = 1 })
	return os.date("*t", time)
end

function M.get_last_day(year, month)
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

function M._print_month(month)
	for i = 1, #month do
		print(table.concat(month[i], " "))
	end
end

function M.build_month(year, month)
	local calendar = {}
	local empty_cell = "  "
	local day = 1

	local first_day = M.get_first_day(year, month).wday
	local last_day = M.get_last_day(year, month).day

	-- insert week days abbreviations
	calendar[1] = {}
	for i = 1, 7 do
		calendar[1][i] = " " .. M.week_days[i].abbreviation
	end

	-- insert days
	for i = 2, 7 do
		calendar[i] = {}
		for j = 1, 7 do
			-- empty -> first week and before start of current month
			if i == 2 and j < first_day then
				calendar[i][j] = empty_cell

			-- always 2 digits
			elseif day <= last_day then
				calendar[i][j] = string.format("%2d", day)
				day = day + 1
			end
		end

		if day > last_day then
			break
		end
	end

	return calendar
end

return M

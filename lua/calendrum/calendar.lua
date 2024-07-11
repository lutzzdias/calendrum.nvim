local M = {}
M.__index = M

function M.generate_header()
	return "Su Mo Tu We Th Fr Sa"
end

function M.get_number_of_days(year, month)
	return os.date("*t", os.time({ year = year, month = month + 1, day = 0 })).day
end

function M.get_starting_weekday(year, month)
	return os.date("*t", os.time({ year = year, month = month, day = 1 })).wday - 1
end

function M.get_current_year()
	return os.date("%Y")
end

function M.get_current_month()
	return os.date("%m")
end

function M.generate_weeks(days_in_month, starting_weekday)
	local weeks = {}
	local week = {}

	for _ = 1, starting_weekday do
		table.insert(week, "  ")
	end

	for day = 1, days_in_month do
		table.insert(week, string.format("%2d", day))
		if #week == 7 then
			table.insert(weeks, table.concat(week, " "))
			week = {}
		end
	end

	if #week > 0 then
		table.insert(weeks, table.concat(week, " "))
	end

	return weeks
end

function M.generate_calendar()
	local year = M.get_current_year()
	local month = M.get_current_month()

	local days_in_month = M.get_number_of_days(year, month)
	local starting_weekday = M.get_starting_weekday(year, month)

	local header = M.generate_header()
	local weeks = M.generate_weeks(days_in_month, starting_weekday)

	table.insert(weeks, 1, header)
	return weeks
end

return M

local M = {}
M.__index = M

function M.get_current_year()
	return os.date("%Y")
end

function M.get_current_month()
	return os.date("%m")
end

function M.get_number_of_days(year, month)
	return os.date("*t", os.time({ year = year, month = month + 1, day = 0 })).day
end

function M.get_starting_weekday(year, month)
	return os.date("*t", os.time({ year = year, month = month, day = 1 })).wday - 1
end

return M

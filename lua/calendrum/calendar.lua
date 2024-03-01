--- @class Day
--- @field date string
--- @field highlight? string hlgroup
--- @field is_today boolean
--- @field opts? table
--
--- @class Month
--- @field days Day[]
--- @field num number
--- @field name string
--- @field year number
--- @field opts? table
--
local M = {}
M.__index = M

function M.new()
	-- create new instance with default values
	local instance = {}

	-- anything not found on instance will be looked up in M, including functions
	setmetatable(instance, M)

	instance:generate_month(2024, 3, {})

	return instance
end

function M:generate_month(year, month, opts)
	-- set the year and month
	self.month = {
		days = M.generate_days(year, month),
		num = month,
		name = os.date("%B", os.time({ year = year, month = month, day = 1 })),
		year = year,
		opts = opts or {},
	}

	return self
end

function M.generate_days(year, month, opts)
	opts = opts or {}

	local num_days = os.date("%d", os.time({ year = year, month = month + 1, day = 0 }))
	local days = {}

	for i = 1, num_days do
		local date = os.date("%Y-%m-%d", os.time({ year = year, month = month, day = i }))
		local day = {
			date = date,
			is_today = date == os.date("%Y-%m-%d"),
			opts = opts,
		}

		if day.is_today then
			day.highlight = "@type"
		end

		table.insert(days, day)
	end

	return days
end

--- @param year number
--- @return boolean
M.is_leap_year = function(year)
	-- if year is divisible by 4 it is a leap year (with exceptions)
	-- exceptions: if year is divisible by 100 and by 400 it is a leap year
	return (year % 4 == 0) and not (year % 100 == 0) or (year % 400 == 0)
end

return M

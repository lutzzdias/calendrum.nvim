local Util = require("calendrum.util")

local M = {
	conditions = Util.highlight.default_highlights(),
	year = Util.date.get_current_year(),
	month = Util.date.get_current_month(),
}
M.__index = M
setmetatable(M, M)

function M:register_condition(condition, highlight)
	table.insert(self.conditions, { condition = condition, highlight = highlight })
end

function M:generate_header()
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

function M:apply_highlights(year, month, day)
	for _, obj in ipairs(self.conditions) do
		if obj.condition(year, month, day) then
			return obj.highlight
		end
	end

	return ""
end

function M:generate_month(y, m)
	y = y or self.year
	m = m or self.month

	local days_in_month = Util.date.get_number_of_days(y, m)
	local starting_weekday = Util.date.get_starting_weekday(y, m)

	local header = self:generate_header()

	local month = {}
	local week = {}

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
			highlight = self:apply_highlights(tonumber(y), tonumber(m), day),
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

M.next_month = function()
	M.month = M.month + 1

	if M.month > 12 then
		M.month = 1
		M.year = M.year + 1
	end

	local c = M:generate_month(M.year, M.month)
	require("calendrum.view.window"):render_month(c)
end

M.prev_month = function()
	M.month = M.month - 1

	if M.month < 1 then
		M.month = 12
		M.year = M.year - 1
	end

	local c = M:generate_month(M.year, M.month)
	require("calendrum.view.window"):render_month(c)
end

return M

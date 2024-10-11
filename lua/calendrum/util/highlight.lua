local M = {}
M.__index = M

function M.define_highlights()
	vim.api.nvim_set_hl(0, "CalendrumHeader", { fg = "#FFFFFF", bold = true })
	vim.api.nvim_set_hl(0, "CalendrumActions", { fg = "#FFFFFF", italic = true })
	vim.api.nvim_set_hl(0, "CalendrumToday", { fg = "#5A8FE6", italic = true })
	vim.api.nvim_set_hl(0, "CalendrumWeekend", { fg = "#5AE68B" })
	vim.api.nvim_set_hl(0, "CalendrumWeekday", { fg = "#FFFFFF" })
end

function M.default_highlights()
	return {
		{
			condition = function(year, month, day)
				local today = os.date("*t")
				return day == today.day and month == today.month and year == today.year
			end,
			highlight = "CalendrumToday",
		},
		{
			condition = function(year, month, day)
				local t = os.time({ year = year, month = month, day = day })
				local weekday = os.date("*t", t).wday
				return weekday == 7 or weekday == 1
			end,
			highlight = "CalendrumWeekend",
		},
	}
end

return M

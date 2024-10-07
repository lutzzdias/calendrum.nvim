local M = {}
M.__index = M

function M.define_highlights()
	vim.api.nvim_set_hl(0, "CalendrumHeader", { fg = "#FFFFFF", bold = true })
	vim.api.nvim_set_hl(0, "CalendrumActions", { fg = "#FFFFFF", italic = true })
	vim.api.nvim_set_hl(0, "CalendrumToday", { fg = "#5A8FE6", italic = true })
	vim.api.nvim_set_hl(0, "CalendrumWeekend", { fg = "#5AE68B" })
	vim.api.nvim_set_hl(0, "CalendrumWeekday", { fg = "#FFFFFF" })
end

return M

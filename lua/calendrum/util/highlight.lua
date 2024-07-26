local M = {}
M.__index = M

function M.define_highlights(namespace)
	vim.api.nvim_set_hl(namespace, "CalendrumHeader", { fg = "#FFFFFF", bold = true })
	vim.api.nvim_set_hl(namespace, "CalendrumActions", { fg = "#FFFFFF", italic = true })
	vim.api.nvim_set_hl(namespace, "CalendrumToday", { fg = "#5A8FE6", italic = true })
	vim.api.nvim_set_hl(namespace, "CalendrumWeekend", { fg = "#5AE68B" })
	vim.api.nvim_set_hl(namespace, "CalendrumWeekday", { fg = "#FFFFFF" })
end

return M

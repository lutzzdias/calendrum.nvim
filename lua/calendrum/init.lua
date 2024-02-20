local M = {}
local ui = require("calendrum.ui")

M.setup = function(opts)
	opts = opts or {}

	vim.keymap.set("n", "<leader>cm", function()
		ui.toggle_calendar()
	end, { noremap = true, silent = true })
end

M.setup()

return M

local Util = require("calendrum.util")

local M = {}

M.setup = function(opts)
	opts = opts or {}

	vim.keymap.set("n", "<leader>cm", function()
		Util.float()
	end, { noremap = true, silent = true })
end

M.setup()

return M

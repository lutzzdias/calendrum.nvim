local View = require("calendrum.view")

local M = {}

M.setup = function(opts)
	opts = opts or {}

	View.create()
end

M.setup()

return M

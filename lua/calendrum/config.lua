local Util = require("calendrum.util")

local M = {}
M.__index = M

function M.setup(opts)
	opts = opts or {}
	Util.highlight.define_highlights()
	Util.keymap.define_keymaps()
	-- TODO: setup
end

return M

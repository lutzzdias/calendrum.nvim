---@class CoreConfig
local M = {}

M.version = "1.0.0"

M.namespace = vim.api.nvim_create_namespace("calendrum")

---@class Config
M.defaults = {
	ui = {
		-- < 1 = percentage
		-- > 1 = fixed size
		size = {
			width = 0.8,
			height = 0.8,
		},
		-- accepts same border values as |nvim_open_win()|
		border = "rounded",
		-- how frequently should the ui process render events
		throttle = 100,
	},
}

---@type Config
M.options = {}

---@param opts Config
function M.setup(opts)
	opts = opts or {}
	M.options = vim.tbl_deep_extend("force", M.options, opts)
end

return M

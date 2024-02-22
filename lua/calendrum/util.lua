---@class Util
local M = {}

M.group = vim.api.nvim_create_augroup("calendrum", { clear = true })

M.mappings = {
	FloatResized = { id = "FloatResized", event = "User", pattern = "CalendrumFloatResized" },
	CalendrumRender = { id = "CalendrumRender", event = "User", pattern = "CalendrumRender" },
}
M.mappings["User FloatResized"] = M.mappings.FloatResized
M.mappings["User CalendrumRender"] = M.mappings.FloatResized

---@param opts? FloatOptions
---@return Float
function M.float(opts)
	local Float = require("calendrum.view.float")
	return Float.new(opts)
end

function M.wo(win, name, value)
	vim.api.nvim_set_option_value(name, value, { scope = "local", win = win })
end

---@param win number
local function setup_notification_window(win)
	local ok = pcall(vim.treesitter.language.add("markdown"))

	if not ok then
		pcall(require, "nvim-treesitter")
	end

	vim.wo[win].conceallevel = 3
	vim.wo[win].concealcursor = ""
	vim.wo[win].spell = false

	local buf = vim.api.nvim_win_get_buf(win)

	if not pcall(vim.treesitter.start, buf, "markdown") then
		vim.bo[buf].filetype = "markdown"
		vim.bo[buf].syntax = "markdown"
	end
end

---@param str string
---@return boolean
function M.is_empty(str)
	return str:match("^%s*$") ~= nil
end

---@param msg string | string[]
---@param log_level? number
function M.notify(msg, log_level)
	log_level = log_level or vim.log.levels.INFO

	if type(msg) == "table" then
		msg = table.concat(
			vim.tbl_filter(function(line)
				return line or false
			end, msg),
			"\n"
		)
	end

	vim.api.nvim_notify({
		msg,
		log_level,
		{
			title = "calendrum.nvim",
			on_open = function(win)
				setup_notification_window(win)
			end,
		},
	})
end

---@param msg string | string[]
function M.error(msg)
	local log_level = vim.log.levels.ERROR
	M.notify(msg, log_level)
end

---@generic F: fun()
---@param ms number
---@param fn F
---@return F
function M.throttle(ms, fn)
	local timer = vim.loop.new_timer()
	local running = false
	local first = true

	return function(...)
		local args = { ... }
		local wrapped = function()
			fn(table.unpack(args))
		end
		if not running then
			if first then
				wrapped()
				first = false
			end

			timer:start(ms, 0, function()
				running = false
				vim.schedule(wrapped)
			end)

			running = true
		end
	end
end

return M

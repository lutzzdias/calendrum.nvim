local Config = require("lazy.config")
local ViewConfig = require("lazy.view.config")
local Colors = require("lazy.view.colors")

---@class FloatOptions
---@field buf? number
---@field size? { width: number, height: number }
---@field margin? { top?: number, right?: number, bottom?: number, left?: number }
---@field persistent? boolean
---@field title? string
---@field style? "minimal"
---@field border? "none" | "single" | "double" | "rounded" | "solid" | "shadow"
---@field zindex? number
---@field noautocmd? boolean
---@field relative? "editor"

---@class WinOpts
---@field width number
---@field height number
---@field row number
---@field col number
---@field title? string
---@field style? "" | "minimal"
---@field border? "none" | "single" | "double" | "rounded" | "solid" | "shadow"
---@field zindex? number
---@field noautocmd? boolean
---@field relative? "editor"

---@class Float
---@field buf number
---@field win number
---@field opts FloatOptions
---@field win_opts WinOpts
---@overload fun(opts?: FloatOptions): Float
local M = {}

---@param opts? FloatOptions
---@return Float
function M.new(opts)
	local self = setmetatable({}, { __index = M })
	return self:init(opts)
end

---@type FloatOptions
M.defaults = {
	size = Config.options.ui.size or Config.defaults.ui.size,
	style = "minimal",
	border = Config.options.ui.border or Config.defaults.ui.border,
	zindex = 50,
	relative = "editor",
}

---@param opts? FloatOptions
---@return Float
function M:init(opts)
	opts = opts or {}
	Colors.setup()

	self.opts = vim.tbl_deep_extend("force", self.defaults, opts)

	self.win_opts = {
		width = self.size(vim.o.columns, self.opts.size.width),
		height = self.size(vim.o.lines, self.opts.size.height),
		row = math.floor((vim.o.lines - self.win_opts.height) / 2),
		col = math.floor((vim.o.columns - self.win_opts.width) / 2),
		title = self.opts.title,
		style = self.opts.style or nil,
		border = self.opts.border,
		zindex = self.opts.zindex,
		noautocmd = self.opts.noautocmd,
		relative = self.opts.relative,
	}

	self:mount()

	self:on_key(ViewConfig.keys.close, self.close)

	self:on({ "BufDelete", "BufHidden" }, self.close, { once = true })

	return self
end

function M:layout()
	if self.opts.border ~= "none" then
		self.win_opts.row = self.win_opts.row - 1
		self.win_opts.col = self.win_opts.col - 1
	end

	if self.opts.margin then
		if self.opts.margin.top then
			self.win_opts.height = self.win_opts.height - self.opts.margin.top
			self.win_opts.row = self.win_opts.row + self.opts.margin.top
		end

		if self.opts.margin.right then
			self.win_opts.width = self.win_opts.width - self.opts.margin.right
		end

		if self.opts.margin.bottom then
			self.win_opts.height = self.win_opts.height - self.opts.margin.bottom
		end

		if self.opts.margin.left then
			self.win_opts.width = self.win_opts.width - self.opts.margin.left
			self.win_opts.col = self.win_opts.col + self.opts.margin.left
		end
	end
end

function M:focus()
	vim.api.nvim_set_current_win(self.win)
	-- TODO: Check if works, lazy had a workaround in `view/float.lua`
end

function M:mount()
	local Util = require("lazy.util")

	if not self:buf_valid() and self.opts.buf then
		self.buf = self.opts.buf
	elseif not self:buf_valid() then
		self.buf = vim.api.nvim_create_buf(false, true)
	end

	self:layout()

	self.win = vim.api.nvim_open_win(self.buf, true, self.win_opts)

	self:focus()

	vim.bo[self.buf].buftype = "nofile"
	vim.bo[self.buf].bufhidden = self.opts.persistent and "hide" or "wipe"

	Util.wo(self.win, "conceallevel", 3)
	Util.wo(self.win, "foldenable", false)
	Util.wo(self.win, "wrap", false)
	Util.wo(self.win, "winhighlight", "Normal:CalendrumNormal")

	vim.api.nvim_create_autocmd("VimResized", {
		callback = function()
			self:resize()
		end,
	})
end

function M:resize()
	if not self:win_valid() then
		return
	end

	self:layout()

	local config = { relative = "editor" }
	for _, key in ipairs({ "width", "height", "col", "row" }) do
		config[key] = self.win_opts[key]
	end

	config.style = self.opts.style or nil
	vim.api.nvim_win_set_config(self.win, config)

	vim.bo[self.buf].bufhidden = self.opts.persistent and "hide" or "wipe"

	Util.wo(self.win, "conceallevel", 3)
	Util.wo(self.win, "foldenable", false)
	Util.wo(self.win, "wrap", false)
	Util.wo(self.win, "winhighlight", "Normal:CalendrumNormal")

	vim.api.nvim_exec_autocmds("User", { pattern = "CalendrumFloatResized", modeline = false })
end

---@param events string | string[]
---@param fn fun(self?): boolean?
---@param opts? table
function M:on(events, fn, opts)
	opts = opts or {}

	if type(events) == "string" then
		events = { events }
	end

	for _, e in ipairs(events) do
		local event, pattern = e:match("(%w+) (%w+)")
		event = event or e

		vim.api.nvim_create_autocmd(
			event,
			vim.tbl_extend("force", {
				pattern = pattern,
				buffer = (not pattern) and self.buf or nil,
				callback = function()
					return fn(self)
				end,
			}, opts)
		)
	end
end

---@param key string
---@param fn fun(self?)
---@param desc? string
function M:on_key(key, fn, desc)
	vim.keymap.set("n", key, function()
		fn(self)
	end, {
		nowait = true,
		buffer = self.buf,
		desc = desc,
	})
end

---@param opts? { wipe:boolean }
function M:close(opts)
	local buf = self.buf
	local win = self.win
	local wipe = opts and opts.wipe or not self.opts.persistent

	self.win = nil
	if wipe then
		self.buf = nil
	end

	vim.schedule(function()
		if win and vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end

		if wipe and buf and vim.api.nvim_buf_is_valid(buf) then
			vim.diagnostic.reset(Config.namespace, buf)
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end)
end

function M:hide()
	if self:win_valid() then
		self:close({ wipe = false })
	end
end

function M:show()
	if self:win_valid() then
		self:focus()
	elseif self:buf_valid() then
		self:mount()
	else
		error("Float: buffer closed")
	end
end

---@return boolean
function M:toggle()
	if self:win_valid() then
		self:hide()
		return false
	else
		self:show()
		return true
	end
end

---@param max number
---@param value number
---@return number
function M.size(max, value)
	return value > 1 and math.min(value, max) or math.floor(max * value)
end

---@return boolean
function M:win_valid()
	return self.win and vim.api.nvim_win_is_valid(self.win)
end

---@return boolean
function M:buf_valid()
	return self.buf and vim.api.nvim_buf_is_valid(self.buf)
end

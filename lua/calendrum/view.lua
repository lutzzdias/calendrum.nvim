local Text = require("calendrum.text")
local Config = require("calendrum.config")

--- @class WinOptions
--- @field relative "editor" | "win" | "cursor" | "mouse"
--- @field width number
--- @field height number
--- @field col number
--- @field row number
--- @field title string
--- @field title_pos "left" | "center" | "right"
--- @field border "none" | "single" | "double" | "rounded" | "solid" | "shadow" | table
--- @field zindex number
--- @field style "minimal"
--
--- @class View
--- @field text Text
--- @field buf? number
--- @field win? number
--- @field opts? WinOptions
local M = {}
M.__index = M

--- @return View
function M.new()
	-- create new instance with default values
	--- @type View
	local instance = {
		buf = nil,
		win = nil,
		text = Text.new(),
		-- TODO: move to config file
		opts = {
			title = "calendrum.nvim",
			title_pos = "center",
			relative = "editor",
			width = M.window_size(0.5, vim.o.columns),
			height = M.window_size(0.5, vim.o.lines),
			col = M.grid_size(0.5, vim.o.columns),
			row = M.grid_size(0.5, vim.o.lines),
			border = "rounded",
			style = "minimal",
			zindex = 50,
		},
	}

	-- anything not found on instance will be looked up in M, including functions
	setmetatable(instance, M)

	return instance
end

--- Used to calculate the width / height of a window
--
--- @param value number
--- @param max number
--- @return number
function M.window_size(value, max)
	if value > 1 then
		-- fixed size
		return math.min(value, max)
	else
		-- % of editor
		return math.floor(max * value)
	end
end

--- Used to calculate the number of rows / columns of a window
--
--- @param value number
--- @param max number
--- @return number
function M.grid_size(value, max)
	return math.floor((max - M.window_size(value, max)) / 2)
end

--- @param opts? WinOptions
function M:create(opts)
	opts = vim.tbl_deep_extend("force", self.opts, opts or {})

	if opts and opts.title then
		opts.title = " " .. opts.title .. " "
	end

	self.buf = vim.api.nvim_create_buf(false, true)
	self.win = vim.api.nvim_open_win(self.buf, false, opts or self.opts)

	-- TODO: understand this better
	vim.api.nvim_buf_set_option(self.buf, "filetype", "Calendrum")
	vim.api.nvim_buf_set_option(self.buf, "buftype", "nofile")
	vim.api.nvim_buf_set_option(self.buf, "bufhidden", "wipe")

	vim.api.nvim_set_current_win(self.win)
end

function M:render()
	vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, self.text.lines)
	for _, hl in ipairs(self.text.hl) do
		vim.api.nvim_buf_add_highlight(self.buf, Config.namespace, hl.group, hl.line, hl.from, hl.to)
	end
end

function M:close()
	local w = self.win
	local b = self.buf
	self.win = nil
	self.buf = nil
	if w and vim.api.nvim_win_is_valid(w) then
		vim.api.nvim_win_close(w, true)
	end

	if b and vim.api.nvim_buf_is_valid(b) then
		vim.api.nvim_buf_delete(b, { force = true })
	end
end

function M:toggle()
	if not self.win and not self.buf then
		self:create()
	else
		self:close()
	end
end

return M

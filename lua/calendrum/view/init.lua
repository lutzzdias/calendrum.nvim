local Config = require("calendrum.config")
local Float = require("calendrum.view.float")
local Renderer = require("calendrum.view.renderer")
local Util = require("calendrum.util")

---@class View: Float
---@field renderer Renderer
local M = {}

---@type View
M.view = nil

---@return boolean
function M.visible()
	return M.view and M.view.win and vim.api.nvim_win_is_valid(M.view.win)
end

function M.show()
	M.view = M.visible() and M.view or M.create()
	M.view:update()
end

function M.create()
	---@type View
	local self = setmetatable({}, { __index = setmetatable(M, { __index = Float }) })

	Float.init(self, {
		title = "calendrum.nvim", --Config.options.ui.title,
		noautocmd = true,
	})

	self.renderer = Renderer.new(self)
	-- self.update = Util.throttle(Config.options.ui.throttle, self.update)
	self.update = Util.throttle(100, self.update)

	self:on({ "User CalendrumRender", "User CalendrumFloatResized" }, function()
		if not (self.buf and vim.api.nvim_buf_is_valid(self.buf)) then
			return true
		end

		self:update()
	end)

	return self
end

function M:update()
	if self.buf and vim.api.nvim_buf_is_valid(self.buf) then
		vim.bo[self.buf].modifiable = true
		self.renderer:update()
		vim.bo[self.buf].modifiable = false
		vim.cmd.redraw()
	end
end

return M

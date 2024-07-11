local Text = require("calendrum.view.text")
local Colors = require("calendrum.view.colors")

---@class Renderer: Text
---@field view View
local M = {}

---@return Renderer
---@param view View
function M.new(view)
	-- TODO: Fix warning
	---@type Renderer
	local self = setmetatable({}, { __index = setmetatable(M, { __index = Text }) })

	self.view = view
	self.padding = 2
	return self
end

function M:update()
	self._lines = {}

	self:title()

	self:trim()
	self:render(self.view.buf)
end

function M:title()
	self:new_line()

	self:new_line()
	local button = " " .. ("previous month"):sub(1, 1):upper() .. " (" .. "h" .. ") "
	self:append(button, Colors.colors.highlight)
	self:new_line()
end

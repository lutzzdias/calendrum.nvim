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

	self:append("Sun Mon Tue Wed Thu Fri Sat")

	self:trim()
	self:render(self.view.buf)
end

return M

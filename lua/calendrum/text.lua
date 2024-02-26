---@class Highlight
---@field group string
---@field line number
---@field from number
---@field to number

---@class Text
---@field lines string[]
---@field hl Highlight[]
local M = {}
M.__index = M

function M.new()
	-- create new instance with default values
	local instance = { lines = {}, hl = {} }

	-- anything not found on instance will be looked up in M, including functions
	setmetatable(instance, M)

	return instance
end

function M.len(str)
	return vim.fn.strwidth(str)
end

function M:new_line()
	table.insert(self.lines, "")
end

--- @param str string
--- @param hl? Highlight
function M:append(str, hl)
	-- split str into lines
	local lines = vim.split(str, "\n")

	-- insert each line into self.lines
	for _, line in ipairs(lines) do
		table.insert(self.lines, line)
	end

	-- no need to setup highlights
	if not hl then
		return
	end

	-- TODO: test and fix
	-- TODO: simplify call (calculate row, from and to)
	self:highlight(hl.line, hl.from, hl.to, "Calendrum" .. hl.group)
end

function M:highlight(row, from, to, group)
	local line = self.lines[row]
	local before = vim.fn.strcharpart(line, 0, from)
	local str = vim.fn.strcharpart(line, 0, to)

	-- column of start of str
	from = vim.fn.strlen(before)

	-- col of end of str
	to = vim.fn.strlen(str)

	local hl = {
		line = row - 1, -- 0 based
		from = from,
		to = to,
		group = group,
	}

	-- add highlight to hl
	table.insert(self.hl, hl)
end

return M

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

--- appends string to last line, if there are \n in str it will be split into
--- multiple lines
--
--- @param str string
--- @param hl? string
function M:append(str, hl)
	-- split str into lines
	local lines = vim.split(str, "\n")

	-- append to last line
	local last_line = table.remove(self.lines) or ""
	last_line = last_line .. lines[1]
	table.insert(self.lines, last_line)

	-- insert each line into self.lines
	for i = 2, #lines do
		table.insert(self.lines, lines[i])
	end

	-- no need to setup highlights
	if not hl then
		return
	end

	-- TODO: pass correct values based on day position
	self:highlight(#lines, 0, #lines[#lines], hl)
end

--- Highlights a range of text (needs refactoring)
--
--- @param row number
--- @param from number
--- @param to number
--- @param group string
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

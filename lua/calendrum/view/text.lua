local Util = require("calendrum.util")
local Config = require("calendrum.config")

---@alias TextSegment {str: string, hl?:string|Extmark}
---@alias Extmark {hl_group?:string, col?:number, end_col?:number}
--
---@class Text
---@field _lines TextSegment[][]
---@field padding? number
local M = {}

---@return Text
function M.new()
	local self = setmetatable({}, {
		__index = M,
	})
	self._lines = {}

	return self
end

function M:new_line()
	table.insert(self._lines, {})
end

function M:trim()
	while #self._lines > 0 and #self._lines[#self._lines] == 0 do
		table.remove(self._lines)
	end
end

---@return number
function M:row()
	if #self._lines == 0 then
		return 1
	end

	return #self._lines
end

---@return number
function M:col()
	if #self._lines == 0 then
		return 0
	end

	local width = 0
	local last_line = self._lines[#self._lines]

	for _, segment in ipairs(last_line) do
		width = width + vim.fn.strwidth(segment.str)
	end

	return width
end

---@param str string
---@param hl? string | Extmark
---@return Text
function M:append(str, hl)
	if #self._lines == 0 then
		self:new_line()
	end

	local lines = vim.split(str, "\n")
	for line_index, line in ipairs(lines) do
		if line_index > 1 then
			self:new_line()
		end

		table.insert(self._lines[#self._lines], {
			str = line,
			hl = hl,
		})
	end

	return self
end

---@param buf number
function M:render(buf)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Hello, world!" })

	local lines = {}

	-- pre processing
	for _, line in ipairs(self._lines) do
		local str = (" "):rep(self.padding)
		local has_extmark = false

		for _, segment in ipairs(line) do
			str = str .. segment.str

			if type(segment.hl) == "table" then
				has_extmark = true
			end
		end

		if Util.is_empty(str) and not has_extmark then
			str = ""
		end

		table.insert(lines, str)
	end

	-- rendering
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_clear_namespace(buf, Config.namespace, 0, -1)

	-- highlighting
	for index, line in ipairs(self._lines) do
		if lines[index] ~= "" then
			local col = self.padding
			local row = index - 1

			for _, segment in ipairs(line) do
				local width = vim.fn.strwidth(segment.str)
				local extmark = segment.hl

				if extmark then
					if type(extmark) == "string" then
						extmark = { hl_group = extmark, end_col = col + width }
					end

					---@cast extmark Extmark
					local extmark_col = extmark.col or col
					extmark.col = nil

					local ok, err =
						pcall(vim.api.nvim_buf_set_extmark, buf, Config.namespace, row, extmark_col, extmark)

					if not ok then
						Util.error(
							"Failed to set extmark. Please report a bug with this info:\n"
								.. vim.inspect({ segment = segment, line = line, error = err })
						)
					end
				end

				col = col + width
			end
		end
	end
end

-- Given a table of regex-like patterns and highlight groups apply highlight to
-- text that matches the pattern
--
---@alias HlGroup string
---@alias Regex string
--
---@param patterns table<Regex, HlGroup>
function M:highlight(patterns)
	local col = self.padding
	local last = self._lines[#self._lines]

	---@type TextSegment?
	local text

	for index, segment in ipairs(last) do
		if index == #last then
			text = segment
			break
		end

		col = col + vim.fn.strwidth(segment.str)
	end

	if text then
		for regex, hl in pairs(patterns) do
			local from, to, match = text.str:find(regex)

			while from do
				if match then
					from, to = text.str:find(match, from, true)
				end

				self:append("", {
					col = col + from - 1,
					end_col = col + to,
					hl_group = hl,
				})

				from, to = text.str:find(regex, to + 1)
			end
		end
	end
end

return M

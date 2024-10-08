---@class Window
---@field win_id number
---@field buf_id number
local M = {}
M.__index = M

-- TODO: accept config as param
function M:new()
	-- default initial values
	local instance = {
		win_id = nil,
		buf_id = nil,
	}

	setmetatable(instance, self)
	return instance
end

function M:_create_buf()
	return vim.api.nvim_create_buf(false, true)
end

function M:_create_win(buf_id, width, height)
	return vim.api.nvim_open_win(buf_id, true, {
		relative = "editor",
		title = "calendrum.nvim",
		title_pos = "center",
		row = math.floor(((vim.o.lines - height) / 2) - 1),
		col = math.floor((vim.o.columns - width) / 2),
		width = width,
		height = height,
		style = "minimal",
		border = "rounded",
	})
end

function M:open()
	local width = math.floor(vim.api.nvim_win_get_width(0) * 0.5)
	local height = math.floor(vim.api.nvim_win_get_height(0) * 0.5)

	local buf_id = self:_create_buf()
	local win_id = self:_create_win(buf_id, width, height)

	self.buf_id = buf_id
	self.win_id = win_id

	return win_id, buf_id
end

function M:close()
	if self.buf_id ~= nil and vim.api.nvim_buf_is_valid(self.buf_id) then
		vim.api.nvim_buf_delete(self.buf_id, { force = true })
	end

	if self.win_id ~= nil and vim.api.nvim_win_is_valid(self.win_id) then
		vim.api.nvim_win_close(self.win_id, true)
	end

	self.win_id = nil
	self.bufnr = nil
end

function M:render_month(month)
	if self.buf_id ~= nil and vim.api.nvim_buf_is_valid(self.buf_id) then
		local lines = {}
		for _, week in ipairs(month) do
			local line_table = {}
			for i, day in ipairs(week) do
				line_table[i] = day.value
			end
			local line = table.concat(line_table, " ")
			table.insert(lines, line)
		end
		vim.api.nvim_buf_set_lines(self.buf_id, 0, -1, false, lines)
		self:apply_highlights(month)
	end
end

function M:apply_highlights(month)
	for week_idx, week in ipairs(month) do
		for day_idx, day in ipairs(week) do
			if day.highlight_group ~= "" then
				vim.api.nvim_buf_add_highlight(
					self.buf_id,
					-1,
					day.highlight,
					week_idx - 1,
					(day_idx - 1) * 3,
					day_idx * 3
				)
			end
		end
	end
end

return M

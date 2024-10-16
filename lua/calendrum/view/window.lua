---@class Window
---@field win_id? number
---@field buf_id? number
local M = {
	win_id = nil,
	buf_id = nil,
}
M.__index = M

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

function M.get_date_from_cursor(year, month)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local cursor_line = cursor_pos[1] -- 1-based index
	local cursor_col = cursor_pos[2] + 1 -- 0-based, add 1 for Lua's indexing

	-- Adjust for the header (day names) being on line 1
	local adjusted_line = cursor_line - 1

	-- Only lines 2 to 7 contain days, if cursor is outside these lines return nil
	if adjusted_line < 1 or adjusted_line > 6 then
		return nil
	end

	-- Calculate the starting day of the month (1 = Sunday, 7 = Saturday)
	local start_day = os.date("*t", os.time({ year = year, month = month, day = 1 })).wday

	-- Calculate which day index in the week the cursor is over
	local day_index_in_week = math.floor((cursor_col - 1) / 3) + 1

	-- Adjust the cursor position: valid slots for each day are in columns 1, 2 for the first slot and 4, 5 for the second, etc.
	if (cursor_col - 1) % 3 ~= 0 and (cursor_col - 1) % 3 ~= 1 then
		return nil -- Not on a valid day number
	end

	-- Calculate the day number based on the line and column
	local day_number = (adjusted_line - 1) * 7 + day_index_in_week

	-- Adjust the day number based on the start day
	if day_number >= start_day then
		day_number = day_number - (start_day - 1)
	else
		return nil -- Not a valid day in the current month
	end

	-- Check if the day exists in the month (avoid returning values larger than the month's total days)
	local last_day_of_month = os.date("*t", os.time({ year = year, month = month + 1, day = 0 })).day
	if day_number > last_day_of_month then
		return nil
	end

	return day_number
end

---@param keymap string
---@param callback function
---@param date { year: number, month: number, day: number }
function M:register_action(keymap, callback, date)
	vim.keymap.set("n", keymap, function()
		callback(date)
	end, {
		noremap = true,
		silent = true,
		buffer = self.buf_id,
	})
end

return M

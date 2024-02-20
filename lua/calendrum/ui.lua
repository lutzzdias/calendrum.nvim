local M = {}

local log = require("calendrum.dev").log
local date = require("calendrum.date")
local popup = require("plenary.popup")

Win_id = nil
Buf_id = nil

local function create_window()
	log.trace("_create_window()")

	local width = 32
	local height = 10
	local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

	Buf_id = vim.api.nvim_create_buf(false, false)
	Win_id = popup.create(Buf_id, {
		title = "Calendrum",
		line = math.floor(((vim.o.lines - height) / 2) - 1),
		col = math.floor((vim.o.columns - width) / 2),
		minwidth = width,
		minheight = height,
		borderchars = borderchars,
	})

	return {
		id = Win_id,
		buf_id = Buf_id,
	}
end

M.toggle_calendar = function()
	log.trace("_toggle_calendar()")

	if Win_id and vim.api.nvim_win_is_valid(Win_id) then
		vim.api.nvim_win_close(Win_id, true)
		Win_id = nil
		Buf_id = nil
		return
	end

	local win = create_window()
	local win_width = vim.api.nvim_win_get_width(win.id)
	local horizontal_padding = string.rep(" ", math.floor((win_width - 20) / 2))
	local contents = {}
	local curr_date = os.date("*t")
	local cal = date.build_month(curr_date.year, curr_date.month)
	local month = os.date("%B - %Y", os.time({ year = curr_date.year, month = curr_date.month, day = curr_date.day }))

	contents[1] = string.rep(" ", math.floor((win_width - #month) / 2)) .. month

	for i = 1, #cal do
		local line_data = table.concat(cal[i], " ")
		contents[i + 1] = horizontal_padding .. line_data .. horizontal_padding
	end

	vim.api.nvim_buf_set_name(win.buf_id, "calendrum")
	vim.api.nvim_buf_set_lines(win.buf_id, 1, #contents, false, contents)
	vim.api.nvim_buf_set_option(win.buf_id, "buftype", "nofile")
	vim.api.nvim_buf_set_option(win.buf_id, "bufhidden", "delete")
end

return M

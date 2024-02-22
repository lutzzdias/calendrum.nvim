local M = {}

---@class ViewCommand
---@field id number
---@field name? string
---@field button? boolean
---@field desc? string
---@field key? string
---@field toggle? boolean

---@type table<string, ViewCommand>
M.commands = {
	next_month = {
		id = 1,
		button = true,
		desc = "Go to next month",
		key = "l",
	},
}

---@type table<string, string | string[]>
M.keys = {
	close = { "q", "<esc>" },
}

function M.get_commands()
	---@type (ViewCommand | { name:string })[]
	local commands = {}

	for name, view_command in pairs(M.commands) do
		view_command.name = name
		commands[#commands + 1] = view_command
	end

	table.sort(commands, function(a, b)
		return a.id < b.id
	end)

	return commands
end

return M

local Util = require("calendrum.util")

local M = {}

---@class Commands
M.commands = {
	next_month = function()
		-- TODO
		-- View.something()
	end,
	prev_month = function()
		-- TODO
		-- View.something()
	end,
}

---@param cmd string
function M.cmd(cmd)
	local command = M.commands[cmd]

	if command == nil then
		Util.error("Invalid calendrum command '" .. cmd .. "'")
	else
		command()
	end
end

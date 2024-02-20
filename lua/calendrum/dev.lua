local M = {}

local log = require("plenary.log")
local reload = require("plenary.reload")

M.log = log.new({ plugin = "calendrum", level = "debug" })

M.reload = function()
	reload.reload_module("calendrum")
end

return M

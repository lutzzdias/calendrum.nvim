-- TODO: Create class
local M = {}

---@type table<string, HlGroup>
M.colors = {
	Border = "FloatBorder",
	Normal = "Normal",
	Today = "Bold",
	Weekend = "Conceal",
	Highlight = "Function",
}

---@type boolean
M.did_setup = false

local function set_hl()
	for title, link in pairs(M.colors) do
		vim.api.nvim_set_hl(0, "Calendrum" .. title, {
			link = link,
			default = true,
		})
	end
end

M.setup = function()
	if M.did_setup then
		return
	end

	M.did_setup = true
	set_hl()

	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = function()
			M.set_hl()
		end,
	})
end

return M

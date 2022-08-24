local M = {}

-- M.setup = function(opts)
-- print("Options:", opts)
-- end

-- functions we need:
--  - vim.keymap.set(...) => create new keymaps
--  - vim.api.nvim_get_keymap(...)

local find_mapping = function(maps, lhs)
	-- pairs
	--		iterates over EVERY key in a table
	--		order not guaranteed
	-- ipairs
	--		iterates over ONLY numeric keys in a table
	--		order IS guaranteed
	for _, value in ipairs(maps) do
		if value.lhs == lhs then
			return value
		end
	end
end

M._stack = {}

M.push = function(name, mode, mappings)
	local maps = vim.api.nvim_get_keymap(mode)

	local existing_maps = {}
	for lhs, rhs in pairs(mappings) do
		local existing = find_mapping(maps, lhs)
		if existing then
			table.insert(existing_maps, existing)
		end
	end

	M._stack[name] = existing_maps

	for lhs, rhs in pairs(mappings) do
		-- TODO: needsome way to pass options in here
		vim.keymap.set(mode, lhs, rhs)
	end
end

M.pop = function(name)
end

M.push("debug_mode", "n", {
	[" st"] = "echo 'Hello'",
	[" so"] = "echo 'Goodbye'",
})
--[[
lua require("mapstack").push("debug_mode", "n", {
	["<leader>st"] = "echo 'Hello'",
	["<leader>sz"] = "echo 'Goodbye'",
})
...
lua require("mapstack").pop("debug_mode")
--]]

return M

local M = {}

M.load = function()
	--require "nick.core.nvim_tree".setup()
	require "nick.core.tokyonight".setup()
	require "nick.core.lualine".setup()
	require "nick.core.nvim_cmp".setup()
	require "nick.core.nvim_tree".setup()
	require "nick.core.symbols_outline".setup()
end

return M

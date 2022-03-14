local M = {}

M.load = function()
	--require "nick.core.tokyonight".setup()
	vim.cmd[[colorscheme onedarker]]
	require "nick.core.lualine".setup()
	require "nick.core.nvim_cmp".setup()
	require "nick.core.nvim_tree".setup()
	require "nick.core.symbols_outline".setup()
	require "nick.core.toggleterm".setup()
end

return M

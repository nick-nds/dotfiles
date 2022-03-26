local M = {}

M.setup = function()
	vim.cmd[[colorscheme gruvbox]]
	-- making background transparent
	vim.cmd[[highlight Normal ctermbg=none]]
end
return M

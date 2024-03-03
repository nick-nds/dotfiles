local M = {}

M.load = function()
	-- require "nick.core.tokyonight".setup()
	-- require "nick.core.gruvbox".setup()
	-- vim.cmd[[colorscheme onedarker]]
    -- break here
	vim.cmd[[set termguicolors]]
	vim.cmd[[let g:nord_uniform_status_lines = 1]]
	vim.cmd[[let g:nord_bold_vertical_split_line = 1]]
	vim.cmd[[let g:nord_uniform_diff_background = 1]]
	vim.cmd[[colorscheme nord]]
	vim.g.copilot_node_command = "~/.nvm/versions/node/v16.13.2/bin/node"
	vim.g.copilot_debug = 1
	require "nick.core.lualine".setup()
	require "nick.core.nvim_cmp".setup()
	require "nick.core.nvim_tree".setup()
	require "nick.core.symbols_outline".setup()
	require "nick.core.toggleterm".setup()
	require "nick.core.git_worktree".setup()
	require "nick.core.harpoon".setup()
	require "nick.core.telescope".setup()
	require "nick.core.lsp".setup()
    require "nick.core.nvim-dap".setup()
end

return M

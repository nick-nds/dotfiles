local M = {}

M.setup = function()
	require("git-worktree").setup({
		change_directory_command =  "tcd", -- default: "cd",
    	update_on_change = true, -- default: true,
    	update_on_change_command = "e .", -- default: "e .",
    	clearjumps_on_change = true, -- default: true,
    	autopush = false, -- default: false,
	})
	require("telescope").load_extension("git_worktree")

    local opts = { noremap = true, silent = ture }
    local kmap = vim.api.nvim_set_keymap
    kmap('n', '<leader>gw', '<cmd>lua require("telescope").extensions.git_worktree.git_worktrees()<cr>',  opts)
    kmap('n', '<leader>gc', '<cmd>lua require("telescope").extensions.git_worktree.create_git_worktree()<cr>',  opts)
end

return M


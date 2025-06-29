return {
    'ThePrimeagen/git-worktree.nvim',
    config = function()
        require("telescope").load_extension("git_worktree")
    end,
    keys = {
        { '<leader>gw', '<cmd>lua require("telescope").extensions.git_worktree.git_worktrees()<cr>' },
        { '<leader>gc', '<cmd>lua require("telescope").extensions.git_worktree.create_git_worktree()<cr>' }
    }
}

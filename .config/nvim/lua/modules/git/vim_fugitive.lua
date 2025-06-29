return {
    'tpope/vim-fugitive',
    cmd = { 'G', 'Git', 'Gdiffsplit', 'Gread', 'Gwrite', 'Ggrep', 'GMove', 'GDelete', 'GBrowse' },
    keys = {
        { '<leader>DD', '<cmd>$tabnew +G<cr>', desc = 'Git status in new tab' },
        { '<leader>gj', '<cmd>diffget //3<cr>', desc = 'Get diff from theirs' },
        { '<leader>gf', '<cmd>diffget //2<cr>', desc = 'Get diff from ours' },
    },
    config = function()
        -- Additional fugitive configuration if needed
        vim.g.fugitive_git_executable = 'git'
    end
}

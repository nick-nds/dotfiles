--telescope bitch
return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        { 'nvim-lua/plenary.nvim' },
        { 'BurntSushi/ripgrep' },
    },
    config = function()
        require("telescope").setup({
            defaults = {
                file_ignore_patterns = { "node_modules", "public/*" }
            }
        })
    end,
    keys = {
        { '<leader>g', '<cmd>lua require("telescope.builtin").grep_string()<cr>' },
        { '<leader>ff', '<cmd>lua require("telescope.builtin").find_files()<cr>' },
        { '<leader>gg', '<cmd>lua require("telescope.builtin").git_files()<cr>' },
        { '<leader>GG', '<cmd>lua require("telescope.builtin").live_grep()<cr>' },
        { '<leader>rr', '<cmd>lua require("telescope.builtin").registers()<cr>' },
        { '<leader>fb', '<cmd>lua require("telescope.builtin").buffers()<cr>' },
    }
}

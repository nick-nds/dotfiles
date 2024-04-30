return {
    'smilovanovic/telescope-search-dir-picker.nvim',
    config = function()
        require('telescope').load_extension('search_dir_picker')
    end,
    keys = {
        { '<leader>sd', '<cmd>lua require("search_dir_picker").search_dir()<cr>' },
    },
}

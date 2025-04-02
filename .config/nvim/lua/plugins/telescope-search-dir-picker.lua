return {
    'smilovanovic/telescope-search-dir-picker.nvim',
    config = function()
        local telescope = require('telescope')
        
        -- Load the search_dir_picker extension
        telescope.load_extension('search_dir_picker')
    end,
    keys = {
        { '<leader>sd', function() 
            -- Use the search_dir function with dropdown theme applied, but keep previewer enabled
            require("search_dir_picker").search_dir()
        end },
    },
}

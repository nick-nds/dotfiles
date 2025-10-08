return {
    'gcmt/taboo.vim',
    lazy = false, -- Load immediately for tabline modification
    config = function()
        -- Set tab format to show filename, modified flag, and tab number
        vim.g.taboo_tab_format = ' %f%m '
        vim.g.taboo_renamed_tab_format = ' [%l]%m '
        vim.g.taboo_modified_tab_flag = '*'
        vim.g.taboo_unnamed_tab_label = '[no name]'
    end
}

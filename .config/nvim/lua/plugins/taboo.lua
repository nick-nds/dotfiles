return {
    'gcmt/taboo.vim',
    config = function()
        vim.cmd([[let g:taboo_tab_format = ' [%N] %f |']])
    end
}

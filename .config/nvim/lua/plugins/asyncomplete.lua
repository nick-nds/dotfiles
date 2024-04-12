return {
    'prabirshrestha/asyncomplete.vim',
    dependencies = {
        { 'prabirshrestha/asyncomplete-lsp.vim' }
    },
    config = function()
        vim.cmd([[
            inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
            inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
            inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
        ]])
    end,
}
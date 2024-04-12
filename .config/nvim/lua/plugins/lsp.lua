return {
    'prabirshrestha/vim-lsp',
    dependencies = {
        { 'mattn/vim-lsp-settings' },
        { 'prabirshrestha/asyncomplete.vim' },
        { 'prabirshrestha/asyncomplete-lsp.vim' },
    },
    config = function()
    end,
    keys = {
        { '<leader>gd', '<cmd>LspDefinition<cr>' },
        { '<leader>gr', '<cmd>LspReferences<cr>' },
        { '<leader>gn', '<cmd>LspNextReference<cr>' },
        { '<leader>lf', '<cmd>LspDocumentRangeFormat<cr>' },
        { '<leader>lF', '<cmd>LspDocumentFormat<cr>' },
    }
}

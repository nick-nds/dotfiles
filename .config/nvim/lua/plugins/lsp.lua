return {
    'prabirshrestha/vim-lsp',
    lazy = false,
    dependencies = {
        { 'mattn/vim-lsp-settings' },
    },
    keys = {
        { '<leader>gd', '<cmd>LspDefinition<cr>' },
        { '<leader>gr', '<cmd>LspReferences<cr>' },
        { '<leader>gn', '<cmd>LspNextReference<cr>' },
        { '<leader>lf', '<cmd>LspDocumentRangeFormat<cr>' },
        { '<leader>lF', '<cmd>LspDocumentFormat<cr>' },
    }
}

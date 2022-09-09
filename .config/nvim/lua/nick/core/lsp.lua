
local M = {}

M.setup = function()
    local opts = { noremap = true, silent = ture }
    local kmap = vim.api.nvim_set_keymap

    --LSP actions
    kmap('n', '<leader>gd', '<cmd>LspDefinition<cr>',  opts)
    kmap('n', '<leader>gr', '<cmd>LspReferences<cr>',  opts)
    kmap('n', '<leader>gn', '<cmd>LspNextReference<cr>',  opts)
    kmap('n', '<leader>lf', '<cmd>LspDocumentRangeFormat<cr>',  opts)
    kmap('n', '<leader>lF', '<cmd>LspDocumentFormat<cr>',  opts)
end

return M

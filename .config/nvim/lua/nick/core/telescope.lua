local M = {}

M.setup = function()
    require("telescope").setup({
        defaults = {
            file_ignore_patterns = { "node_modules", "public/*" }
        }
    })

    local opts = { noremap = true, silent = ture }
    local kmap = vim.api.nvim_set_keymap
    --Telescope Maps
    kmap('n', '<leader>g', '<cmd>lua require("telescope.builtin").grep_string()<cr>',  opts)
    kmap('n', '<leader>ff', '<cmd>lua require("telescope.builtin").find_files()<cr>',  opts)
    kmap('n', '<leader>gg', '<cmd>lua require("telescope.builtin").git_files()<cr>',  opts)
    kmap('n', '<leader>GG', '<cmd>lua require("telescope.builtin").live_grep()<cr>',  opts)
    kmap('n', '<leader>rr', '<cmd>lua require("telescope.builtin").registers()<cr>',  opts)
end

return M


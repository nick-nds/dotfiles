local M = {}

M.setup = function()
    require("harpoon").setup({
        menu = {
            width = vim.api.nvim_win_get_width(0) - 100,
        }
    })
    require("telescope").load_extension('harpoon')

    local opts = { noremap = true, silent = ture }
    local kmap = vim.api.nvim_set_keymap
    kmap('n', '<leader>hh', '<cmd>Telescope harpoon marks<cr>',  opts)
    kmap('n', '<leader>ha', '<cmd>lua require("harpoon.mark").add_file()<cr>',  opts)
    kmap('n', '<leader>HH', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>',  opts)
    kmap('n', '<C-n>', '<cmd>lua require("harpoon.ui").nav_next()<cr>',  opts)
    kmap('n', '<C-N>', '<cmd>lua require("harpoon.ui").nav_prev()<cr>',  opts)
    kmap('n', '<leader>h', '<cmd>lua require("harpoon.ui").nav_file(vim.v.count1)<cr>',  opts)

end

return M

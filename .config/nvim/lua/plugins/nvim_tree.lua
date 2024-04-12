return {
    'nvim-tree/nvim-tree.lua',
    config = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        require("nvim-tree").setup()
    end,
    keys = {
        { '<leader>n', '<cmd>NvimTreeToggle<cr>' }, --toggle NvimTree
        { '<leader>r', '<cmd>NvimTreeRefresh<cr>' }, --refresh NvimTree
    }
}

local M = {}

M.setup = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    local function my_on_attach(bufnr)
        local api = require "nvim-tree.api"

        local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- custom mappings
        vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts('Up'))
        vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
    end

    require 'nvim-tree'.setup({
        sort = {
            sorter = "case_sensitive",
        },
        view = {
            width = 30,
        },
        renderer = {
            group_empty = true,
        },
        filters = {
            dotfiles = true,
        },
        on_attach = my_on_attach,
    })

    local opts = { noremap = true, silent = true }
    local kmap = vim.api.nvim_set_keymap

    -- Nvim Tree maps
    kmap('n', '<leader>n', '<cmd>NvimTreeToggle<cr>', opts) --toggle NvimTree
    kmap('n', '<leader>r', '<cmd>NvimTreeRefresh<cr>', opts) --refresh NvimTree
end

return M

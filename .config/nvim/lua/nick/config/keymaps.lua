local opts = { noremap = true, silent = ture }
local term_opts = { silent = true }
local kmap = vim.api.nvim_set_keymap

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Pane Navigation
kmap('n', '<C-h>', '<C-w>h', opts)
kmap('n', '<C-j>', '<C-w>j', opts)
kmap('n', '<C-k>', '<C-w>k', opts)
kmap('n', '<C-l>', '<C-w>l', opts)

--Telescope Maps
kmap('n', '<leader>ff', '<cmd>lua require("telescope.builtin").find_files()<cr>',  opts)
kmap('n', '<leader>gg', '<cmd>lua require("telescope.builtin").git_files()<cr>',  opts)
kmap('n', '<leader>GG', '<cmd>lua require("telescope.builtin").live_grep()<cr>',  opts)

--LSP actions
kmap('n', '<leader>gd', '<cmd>LspDefinition<cr>',  opts)
kmap('n', '<leader>gr', '<cmd>LspReferences<cr>',  opts)
kmap('n', '<leader>gn', '<cmd>LspNextReference<cr>',  opts)
kmap('n', '<leader>lf', '<cmd>LspDocumentRangeFormat<cr>',  opts)
kmap('n', '<leader>lF', '<cmd>LspDocumentFormat<cr>',  opts)

--fugitive vim maps
kmap('n', '<leader>gd', ':G<cr>',  opts)
kmap('n', '<leader>gj', ':diffget //3<cr>',  opts)
kmap('n', '<leader>gf', ':diffget //2<cr>',  opts)


--simple remaps
kmap('n', '<leader>e', '<cmd>q<cr>',  opts) --quit vim
kmap('n', '<leader>q', '<cmd>qa<cr>',  opts) --quit vim
kmap('n', '<leader>T', '<cmd>tabclose<cr>',  opts) --close active tab
kmap('n', '<leader>t', '<cmd>tabs<cr>',  opts) --view tabs

--autocomplete setup
vim.cmd[[inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"]]
vim.cmd[[inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"]]

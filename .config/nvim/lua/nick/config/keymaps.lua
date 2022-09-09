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

--fugitive vim maps
kmap('n', '<leader>DD', ':$tabnew +G<cr>',  opts)
kmap('n', '<leader>gj', ':diffget //3<cr>',  opts)
kmap('n', '<leader>gf', ':diffget //2<cr>',  opts)


--simple remaps
kmap('n', '<leader>e', '<cmd>q<cr>',  opts) --quit vim
kmap('n', '<leader>q', '<cmd>qa<cr>',  opts) --quit vim
kmap('n', '<leader>T', '<cmd>tabclose<cr>',  opts) --close active tab
kmap('n', '<leader>t', '<cmd>tabs<cr>',  opts) --view tabs
kmap('n', '<C-t>', '<cmd>tabnew<cr>',  opts) --new tab
kmap('n', '<C-left>', '<cmd>tabmove -1<cr>',  opts) --move tab left
kmap('n', '<C-right>', '<cmd>tabmove +1<cr>',  opts) --move tab right
kmap('n', '<leader>b', '<C-^>',  opts) --move tab right

--autocomplete setup
-- vim.cmd[[inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"]]
-- vim.cmd[[inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"]]
-- vim.cmd[[inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"]]
vim.cmd[[function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"]]

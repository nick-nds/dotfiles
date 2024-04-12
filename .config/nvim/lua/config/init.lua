local opts = { noremap = true, silent = ture }

-- Pane Navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

--simple remaps
vim.keymap.set('n', '<leader>e', '<cmd>q<cr>',  opts) --quit vim
vim.keymap.set('n', '<leader>q', '<cmd>qa<cr>',  opts) --quit vim
vim.keymap.set('n', '<leader>T', '<cmd>tabclose<cr>',  opts) --close active tab
vim.keymap.set('n', '<leader>t', '<cmd>tabs<cr>',  opts) --view tabs
vim.keymap.set('n', '<C-t>', '<cmd>tabnew<cr>',  opts) --new tab
vim.keymap.set('n', '<C-left>', '<cmd>tabmove -1<cr>',  opts) --move tab left
vim.keymap.set('n', '<C-right>', '<cmd>tabmove +1<cr>',  opts) --move tab right
vim.keymap.set('n', '<leader>b', '<C-^>',  opts)


-- basic vim settings
local options = require("config.options")

vim.opt.shortmess:append "c"
vim.opt.whichwrap:append "<,>,[,],h,l"

-- Make compatible with st, truecolors
vim["&t_8f"] = "\\<Esc>[38;2;%lu;%lu;%lum"
vim["&t_8b"] = "\\<Esc>[48;2;%lu;%lu;%lum"
vim.opt.termguicolors = true

-- Macros
vim.cmd [[set formatoptions-=cro]]

for k, v in pairs(options) do
    vim.opt[k] = v
end

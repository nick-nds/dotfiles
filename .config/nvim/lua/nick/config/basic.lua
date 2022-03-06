local set = vim.opt

--set.foldmethod = indent

set.relativenumber = true --set relative line number

--indent settings
set.autoindent = true  --respect indentation when starting a new line
set.tabstop = 4 --show existing tab with 4 spaces
set.softtabstop = 4
set.shiftwidth = 4 --when indenting with '>', use 4 spaces
set.expandtab = true --on pressing tab, insert 4 spaces
set.smartindent = true

set.hidden = true --keep any buffer open in background
set.wrap = true --wrap lines longer than width of window

--hsitory settings
-- set.noswapfile = true --load files without creating swap file.
-- set.nobackup = true --delete backup file on :w
-- set.undodir = '~/.vim/undodir' --dir for undo files
-- set.undofile = true --return the name of undo file that would be used for {name} when writing, usage: undofile({name})

-- set.incsearch = true --Set incremental search i.e. highlight as u search
-- set.scrolloff = 8 --keep my cursor in center
-- 
-- set.colorcolumn = 200 --A bar to alert to not exceed code across this line
-- set.signcolumn = yes --Add extra column for linting error
-- 
-- --Give more space to display messages
-- set.cmdheight = 2

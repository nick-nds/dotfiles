local set = vim.opt

set.relativenumber --set relative line number

--indent settings
set.autoindent  --respect indentation when starting a new line
set.tabstop = 4
set.softtabstop = 4
set.smartindent

set.hidden --keep any buffer open in background
set.wrap --wrap lines longer than width of window

--hsitory settings
set.noswapfile --load files without creating swap file.
set.nobackup --delete backup file on :w
set.undodir = ~/.vim/undodir --dir for undo files
set.undofile --return the name of undo file that would be used for {name} when writing, usage: undofile({name})

set.incsearch --Set incremental search i.e. highlight as u search
set.scrolloff = 8 --keep my cursor in center

set.colorcolumn = 200 --A bar to alert to not exceed code across this line
set.signcolumn = yes --Add extra column for linting error

--Give more space to display messages
set cmdheight=2

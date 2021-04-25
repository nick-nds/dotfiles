set foldmethod=indent
syntax on
filetype plugin indent on

set guicursor=
set relativenumber
set nu
set nohlsearch "No highlight search

set autoindent             " Respect indentation when starting a new line.
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent

set hidden "Keep any buffer open in background
set noerrorbells
set nowrap

"Keeping history
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile

set incsearch "Set incremental search i.e. highlight as u search
set scrolloff=8 "keep my cursor in center

set colorcolumn=80 "A bar to alert to not exceed code across this line
set signcolumn=yes "Add extra column for linting error

"Give more space to display messages
set cmdheight=2

"Plugin Manager, vim-plug
call plug#begin('~/.vim/plugged')
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'gruvbox-community/gruvbox'
"Plug 'vim-syntastic/syntastic' "Syntax checking plugin
Plug 'dbeniamine/cheat.sh-vim' "Vim support for cheat.sh

Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings' "LspInstallServer type things
Plug 'nvim-lua/completion-nvim' "Autocomplete
Plug 'tjdevries/nlua.nvim'
Plug 'tjdevries/lsp_extensions.nvim'

"Plug 'prabirshrestha/asyncomplete.vim'
"Plug 'prabirshrestha/asyncomplete-lsp.vim'

Plug 'nathanaelkane/vim-indent-guides' "Show indent guides

Plug 'mattn/emmet-vim' "Emmet vim

Plug 'tpope/vim-commentary' "Commenting

Plug 'neoclide/coc.nvim', {'branch': 'release'} " coc plugin

"Plug 'iamcco/coc-tailwindcss',  {'do': 'yarn install --frozen-lockfile && yarn run build'} "tailwind intellisense

Plug 'rodrigore/coc-tailwind-intellisense', {'do': 'npm install'}


"Plug 'turbio/bracey.vim' "Live edit

call plug#end()

"let g:syntastic_python_checkers = ['pylint']
"let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']

let g:gruvbox_improved_warnings=1
let g:gruvbox_italicize_comments=1
let g:gruvbox_italicize_strings=1
colorscheme gruvbox

"Map leader key to space
let mapleader = " "

"Remaps
"mode lhs rhs
"nore no recursive execution

" switch between spilts
" 3 <leader>ss will switch 3 times
nnoremap <leader>ss <c-w><c-w>


"=============================
"=============================
"Telescope maps
"=============================
"=============================


"============
"File Pickers
"============
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>* <cmd>Telescope grep_string<cr>



"============
"Vim Pickers
"============
nnoremap <leader>r <cmd>Telescope registers<cr>
nnoremap <leader>m <cmd>Telescope marks<cr>


"git commands maps
nnoremap <leader>gst <cmd>Telescope git_status<cr>


"============
"Defenitions and References - LSP settings
"============


"Go to the definition of the word under the cursor, and open in the current window
nnoremap <leader>gd <cmd>LspDefinition<cr>

"Find references
nnoremap <leader>gr <cmd>LspReferences<cr>

"jump to next reference to the symbol under cursor
nnoremap <leader>gn <cmd>LspNextReference<cr>

"Gets a list of possible commands that can be applied to a file so it can be fixed (quick fix)
nnoremap <leader>gf <cmd>LspCodeAction<cr>

"Format document selection
nnoremap <leader>lf <cmd>LspDocumentRangeFormat<cr>

"Format entire document
nnoremap <leader>lF <cmd>LspDocumentFormat<cr>


"============
"Quiting vim
"============
nnoremap <leader>e <cmd>q<cr>


" write and refresh in browser
cmap ww<cr> w<cr> :silent! !~/bin/refresh<cr>


" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c


" Use tab for trigger completion with characters ahead and navigate.
" other plugin before putting this into your config.
"inoremap <silent><expr> <TAB>
"    \ pumvisible() ? "\<C-n>" :
"    \ <SID>check_back_space() ? "\<TAB>" :
"    \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"
"function! s:check_back_space() abort
"    let col = col('.') - 1
"    return !col || getline('.')[col - 1]  =~# '\s'
"endfunction

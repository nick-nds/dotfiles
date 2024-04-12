return {

	 --telescope recommended dependcies
	 { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
	 {'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	 --lua `fork` of vim-web-devicons for neovim
	 'kyazdani42/nvim-web-devicons',

	 'christoomey/vim-system-copy',

	 --A git blame plugin for neovim inspired by VS Code's GitLens plugin
	 'APZelos/blamer.nvim',

	 --emmet
	 'mattn/emmet-vim',

	 -- vim's popup api to neovim
	 'nvim-lua/popup.nvim',

    -- tpope's comment
    'tpope/vim-commentary',

    -- A Vim plugin that manages your tag files
    'ludovicchabant/vim-gutentags',

    -- Vim plugin that displays tags in a window, ordered by scope
    'preservim/tagbar',

    -- A lightweight Vim/Neovim plugin to display buffers and tabs in the tabline 
    -- 'pacha/vem-tabline',
}

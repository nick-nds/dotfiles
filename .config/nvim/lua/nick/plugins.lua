return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
	
	--telescope bitch
	use {
		'nvim-telescope/telescope.nvim',
		requires = { 
			{ 'nvim-lua/plenary.nvim' },
			{ 'BurntSushi/ripgrep' },
		}
	}
	--telescope recommended dependcies
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
	use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
	--lua `fork` of vim-web-devicons for neovim
	use { 'kyazdani42/nvim-web-devicons' }

	--Auto configurations for LSP
	use { 'prabirshrestha/vim-lsp' }
	use { 'mattn/vim-lsp-settings' }

	--autocomplete
	use { 'nvim-lua/completion-nvim' }


	--indent guide
	use { "lukas-reineke/indent-blankline.nvim" }

	--Renaming tab labels
	use { 'gcmt/taboo.vim' }

	use { 'christoomey/vim-system-copy' }

	--A git blame plugin for neovim inspired by VS Code's GitLens plugin 
	use { 'APZelos/blamer.nvim' }

	-- a neovim theme written in lua
	    --use { 'morhetz/gruvbox' }
	use { 'folke/tokyonight.nvim' }

	--a git wrapper for vim
	use { 'tpope/vim-fugitive' }

	--airline
	--use { 'vim-airline/vim-airline' }
	--use { 'vim-airline/vim-airline-themes' }
	use { 'nvim-lualine/lualine.nvim', 
		requires = { 'kyazdani42/nvim-web-devicons', opt = true } 
	}
end)


vim.cmd [[packadd packer.nvim]]
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

	use { 'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}

	--tree like view for symbols
	use { 'simrat39/symbols-outline.nvim' }

	--a file explorer tree for neovim written in lua
	use {
		'kyazdani42/nvim-tree.lua',
		requires = {
		  'kyazdani42/nvim-web-devicons', -- optional, for file icon
		},
		config = function() require'nvim-tree'.setup {} end
	}

	--emmet
	use { 'mattn/emmet-vim' }

	--completion
	use { 'neovim/nvim-lspconfig' }
	use { 'hrsh7th/cmp-nvim-lsp' }
	use { 'hrsh7th/cmp-buffer' }
	use { 'hrsh7th/cmp-path' }
	use { 'hrsh7th/cmp-cmdline' }
	use { 'hrsh7th/nvim-cmp' }

	--For luasnip users.
	use { 'L3MON4D3/LuaSnip' }
	use { 'saadparwaiz1/cmp_luasnip' }

	--neovim lua plugin to help easily manage multiple terminal windows
	use { "akinsho/toggleterm.nvim" }

	use { "lunarvim/onedarker.nvim" }

	--indent guide
	-- use { "nathanaelkane/vim-indent-guides" }

	--gruvbox
	use { 'gruvbox-community/gruvbox' }

	--Nord theme
	use { 'arcticicestudio/nord-vim' , branch  = 'develop' }
end)


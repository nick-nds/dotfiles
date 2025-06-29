-- Neovim Configuration Entry Point

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader keys before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Load core configurations
require('core.options')
require('core.keymaps')

-- Load all plugin modules (only actual plugin specs)
local modules = {
  -- LSP and formatting
  require('modules.lsp'),
  require('modules.completion'),
  
  -- Editor enhancements
  { import = 'modules.editor' },
  
  -- UI and appearance
  { import = 'modules.ui' },
  
  -- Git integration
  { import = 'modules.git' },
  
  -- Tools and utilities
  require('modules.tools.toggleterm'),
  require('modules.tools.nvim-dap'),
  require('modules.tools.neotest'),
  require('modules.tools.neorg'),
  require('modules.tools.obsidian-nvim'),
  require('modules.tools.emmet'),
  
  -- Miscellaneous plugins
  { import = 'modules.misc' },
}

-- Initialize lazy.nvim with aggressive performance optimizations
require('lazy').setup(modules, {
  defaults = {
    lazy = true, -- Make all plugins lazy by default
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit", 
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        "logipat",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
      },
    },
  },
  install = {
    missing = false, -- Don't auto-install missing plugins
    colorscheme = { "gruvbox" }, -- Use gruvbox during installation
  },
  checker = {
    enabled = false, -- Disable automatic plugin update checking
  },
})
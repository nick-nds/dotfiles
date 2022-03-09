local M = {}

function M:load()
    require "nick.config.keymaps"
    require "nick.config.options".load_options()

    vim.g.tokyonight_style = "storm"
    vim.g.tokyonight_transparent = true
    vim.cmd[[colorscheme tokyonight]]

    require('lualine').setup {
		options = {
		   theme = 'tokyonight'
		}
    }

	require "nick.config.plugins.symbols_outline"
	require "nick.config.plugins.nvim_tree"
    -- local colorscheme = "tokyonight"
    --local colorscheme = "gruvbox"

end

return M

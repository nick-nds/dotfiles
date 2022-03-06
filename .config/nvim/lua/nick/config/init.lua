local M = {}

function M:load()
    require "nick.config.keymaps"
    require "nick.config.options".load_options()

    vim.g.tokyonight_style = "night"
    vim.g.tokyonight_transparent = true
    vim.cmd[[colorscheme tokyonight]]

    require('lualine').setup {
		options = {
		   theme = 'tokyonight'
		}
    }
    -- local colorscheme = "tokyonight"
    --local colorscheme = "gruvbox"

end

return M

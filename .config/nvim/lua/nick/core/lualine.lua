local M = {}

M.setup = function()
    require('lualine').setup {
		options = {
		   theme = 'tokyonight'
		}
    }
end

return M

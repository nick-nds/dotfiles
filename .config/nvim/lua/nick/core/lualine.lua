local M = {}

M.setup = function()
    require('lualine').setup {
		options = {
		   theme = 'tokyonight'
		},
        sections = {
            lualine_a = {
                {
                    'filename',
                    file_status = true,
                    path = 1
                }
            }
        }
    }
end

return M

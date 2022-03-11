local M = {}

M.setup = function()
    vim.g.tokyonight_style = "night"
    vim.g.tokyonight_transparent = true
    vim.cmd[[colorscheme tokyonight]]
end

return M

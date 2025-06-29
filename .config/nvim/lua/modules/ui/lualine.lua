return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 
        { 'kyazdani42/nvim-web-devicons', opts = true }
    },
    config = function()
        require('lualine').setup({
            options = {
               theme = 'gruvbox'
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
        })
    end,
}

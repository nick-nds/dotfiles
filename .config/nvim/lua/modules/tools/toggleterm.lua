return {
    'akinsho/toggleterm.nvim',
    version = "*",
    keys = {
        [[<c-\>]]
    },
    config = function()
        require("toggleterm").setup({
            open_mapping = [[<c-\>]],
            direction = 'float',
            float_opts = {
                border = 'curved',
                winblend = 0,
            },
            highlights = {
                Normal = {
                    guibg = "NONE",
                },
                NormalFloat = {
                    link = 'Normal'
                },
                FloatBorder = {
                    guifg = "#928374",
                },
            },
        })
    end
}

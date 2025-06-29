return {
    "ellisonleao/gruvbox.nvim",
    lazy = false, -- Keep colorscheme immediate
    priority = 1000,
    config = function()
        require("gruvbox").setup({
            contrast = "hard", -- can be "hard", "soft" or empty string
        })
        vim.o.background = "dark"
        vim.cmd([[colorscheme gruvbox]])
    end,
}

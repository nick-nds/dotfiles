return {
    "zbirenbaum/copilot-cmp",
    cond = function()
        return vim.g.copilot_enabled
    end,
    config = function()
        require("copilot_cmp").setup()
    end,
}

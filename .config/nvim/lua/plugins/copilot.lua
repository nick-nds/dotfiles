-- Global flag to easily enable/disable Copilot
vim.g.copilot_enabled = false -- Set to false to completely disable Copilot

return {
    "zbirenbaum/copilot.lua",
    cond = function()
        return vim.g.copilot_enabled
    end,
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
        require("copilot").setup({
            suggestion = {
                enabled = false
            },
            panel = {
                enabled = false
            }
        })
    end,
}
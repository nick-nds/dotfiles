return {
    'toppair/peek.nvim',
    config = function()
        local peek = require("peek")
        peek.setup({
            app = { 'google-chrome', '--new-window' },
        })
        vim.api.nvim_create_user_command("PeekOpen", peek.open, {})
        vim.api.nvim_create_user_command("PeekClose", peek.close, {})
    end
}

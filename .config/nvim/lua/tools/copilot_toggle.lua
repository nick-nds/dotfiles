-- Tool to toggle Copilot state
local M = {}

-- Function to toggle Copilot state
M.toggle = function()
    vim.g.copilot_enabled = not vim.g.copilot_enabled
    
    if vim.g.copilot_enabled then
        print("Copilot enabled - will take effect after restart")
    else
        print("Copilot disabled - will take effect after restart")
    end
end

-- Function to check Copilot state
M.status = function()
    if vim.g.copilot_enabled then
        print("Copilot is enabled")
    else
        print("Copilot is disabled")
    end
end

-- Create commands
vim.api.nvim_create_user_command("CopilotToggle", function()
    M.toggle()
end, {})

vim.api.nvim_create_user_command("CopilotStatus", function()
    M.status()
end, {})

-- Create keybinding
vim.keymap.set("n", "<leader>ct", ":CopilotToggle<CR>", 
              { noremap = true, silent = true, desc = "Toggle Copilot" })
vim.keymap.set("n", "<leader>cs", ":CopilotStatus<CR>", 
              { noremap = true, silent = true, desc = "Copilot Status" })

return M
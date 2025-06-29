-- Tailwind CSS LSP Control Utility
-- Manage Tailwind CSS LSP to prevent resource issues

local M = {}

-- Track Tailwind LSP state
local tailwind_enabled = true

-- Get Tailwind clients
local function get_tailwind_clients()
  local clients = {}
  for _, client in pairs(vim.lsp.get_active_clients()) do
    if client.name == "tailwindcss" then
      table.insert(clients, client)
    end
  end
  return clients
end

-- Disable Tailwind CSS LSP
function M.disable_tailwind()
  local clients = get_tailwind_clients()
  
  if #clients == 0 then
    vim.notify("No active Tailwind CSS LSP clients found", vim.log.levels.WARN)
    return
  end
  
  for _, client in pairs(clients) do
    client.stop()
  end
  
  tailwind_enabled = false
  vim.notify("Tailwind CSS LSP disabled (" .. #clients .. " clients stopped)", vim.log.levels.INFO)
end

-- Enable Tailwind CSS LSP
function M.enable_tailwind()
  if tailwind_enabled then
    vim.notify("Tailwind CSS LSP is already enabled", vim.log.levels.INFO)
    return
  end
  
  -- Restart LSP for current buffer if it's a supported filetype
  local supported_filetypes = {
    "html", "css", "scss", "javascript", "javascriptreact", 
    "typescript", "typescriptreact", "vue", "svelte", "php"
  }
  
  local current_ft = vim.bo.filetype
  if vim.tbl_contains(supported_filetypes, current_ft) then
    vim.cmd("LspRestart tailwindcss")
    tailwind_enabled = true
    vim.notify("Tailwind CSS LSP enabled for " .. current_ft .. " files", vim.log.levels.INFO)
  else
    vim.notify("Current filetype (" .. current_ft .. ") not supported by Tailwind CSS LSP", vim.log.levels.WARN)
  end
end

-- Toggle Tailwind CSS LSP
function M.toggle_tailwind()
  if tailwind_enabled then
    M.disable_tailwind()
  else
    M.enable_tailwind()
  end
end

-- Monitor resource usage and auto-disable if needed
function M.monitor_resources()
  local clients = get_tailwind_clients()
  
  for _, client in pairs(clients) do
    -- Check if client is responsive
    local success = pcall(function()
      client.request("workspace/executeCommand", {
        command = "tailwindCSS.showOutput",
      })
    end)
    
    if not success then
      vim.notify("Tailwind CSS LSP appears unresponsive, consider disabling", vim.log.levels.WARN)
    end
  end
end

-- Check LSP status
function M.status()
  local clients = get_tailwind_clients()
  
  if #clients == 0 then
    print("Tailwind CSS LSP: Not active")
  else
    print("Tailwind CSS LSP: " .. #clients .. " active client(s)")
    for i, client in pairs(clients) do
      local buffers = {}
      for _, buf in pairs(vim.lsp.get_buffers_by_client_id(client.id)) do
        table.insert(buffers, buf)
      end
      print("  Client " .. i .. ": " .. #buffers .. " buffer(s) attached")
    end
  end
  
  print("State: " .. (tailwind_enabled and "Enabled" or "Disabled"))
end

-- Restart Tailwind CSS LSP
function M.restart_tailwind()
  vim.notify("Restarting Tailwind CSS LSP...", vim.log.levels.INFO)
  M.disable_tailwind()
  vim.defer_fn(function()
    M.enable_tailwind()
  end, 1000)
end

-- Enable performance mode (placeholder - could disable features)
function M.enable_performance_mode()
  -- For now, this just disables Tailwind as a performance optimization
  M.disable_tailwind()
  vim.notify("Tailwind CSS performance mode enabled (LSP disabled)", vim.log.levels.INFO)
end

-- Disable performance mode
function M.disable_performance_mode()
  -- Re-enable Tailwind LSP
  M.enable_tailwind()
  vim.notify("Tailwind CSS performance mode disabled (LSP enabled)", vim.log.levels.INFO)
end

-- Setup commands and keybindings
function M.setup()
  -- Commands
  vim.api.nvim_create_user_command("TailwindDisable", M.disable_tailwind, 
    { desc = "Disable Tailwind CSS LSP" })
  
  vim.api.nvim_create_user_command("TailwindEnable", M.enable_tailwind, 
    { desc = "Enable Tailwind CSS LSP" })
  
  vim.api.nvim_create_user_command("TailwindToggle", M.toggle_tailwind, 
    { desc = "Toggle Tailwind CSS LSP" })
  
  vim.api.nvim_create_user_command("TailwindStatus", M.status, 
    { desc = "Show Tailwind CSS LSP status" })
  
  -- Keybindings (matching documentation)
  vim.keymap.set("n", "<leader>tws", M.enable_tailwind, 
    { desc = "Start Tailwind CSS LSP" })
  vim.keymap.set("n", "<leader>twk", M.disable_tailwind, 
    { desc = "Stop/Kill Tailwind CSS LSP" })
  vim.keymap.set("n", "<leader>twr", M.restart_tailwind, 
    { desc = "Restart Tailwind CSS LSP" })
  vim.keymap.set("n", "<leader>twt", M.toggle_tailwind, 
    { desc = "Toggle Tailwind CSS LSP" })
  vim.keymap.set("n", "<leader>twp", M.enable_performance_mode, 
    { desc = "Enable Tailwind performance mode" })
  vim.keymap.set("n", "<leader>twn", M.disable_performance_mode, 
    { desc = "Disable Tailwind performance mode" })
  vim.keymap.set("n", "<leader>twi", M.status, 
    { desc = "Show Tailwind CSS LSP status" })
  
  -- Auto-monitor timer (check every 30 seconds)
  local timer = vim.loop.new_timer()
  if timer then
    timer:start(30000, 30000, vim.schedule_wrap(M.monitor_resources))
  end
  
  -- Auto-disable on memory pressure (if available)
  vim.api.nvim_create_autocmd("User", {
    pattern = "LspDiagnosticsChanged",
    callback = function()
      -- Check for excessive diagnostics which might indicate resource issues
      local diagnostics = vim.diagnostic.get()
      if #diagnostics > 1000 then
        vim.notify("High diagnostic count detected, consider disabling Tailwind CSS LSP", vim.log.levels.WARN)
      end
    end,
  })
end

return M
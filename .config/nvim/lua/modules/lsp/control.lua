-- LSP Resource Control and Monitoring
-- Comprehensive system to manage LSP performance and resource usage

local M = {}

-- Configuration
local config = {
  max_clients = 6, -- Maximum number of LSP clients
  memory_check_interval = 30000, -- Check every 30 seconds
  max_diagnostics_per_buffer = 50, -- Limit diagnostics per buffer
  debounce_increase_threshold = 5, -- Number of warnings before increasing debounce
  auto_restart_threshold = 10, -- Number of errors before auto-restart
}

-- Statistics tracking
local stats = {
  warnings = {},
  errors = {},
  last_memory_check = 0,
  performance_issues = {},
}

-- Get all active LSP clients
local function get_active_clients()
  local clients = {}
  -- Use new API if available (Neovim 0.10+)
  local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
  for _, client in pairs(get_clients()) do
    table.insert(clients, {
      id = client.id,
      name = client.name,
      buffers = vim.lsp.get_buffers_by_client_id(client.id),
      root_dir = client.config.root_dir,
    })
  end
  return clients
end

-- Check LSP resource usage
function M.check_resources()
  local clients = get_active_clients()
  local issues = {}
  
  -- Check number of clients
  if #clients > config.max_clients then
    table.insert(issues, string.format("Too many LSP clients: %d (max: %d)", #clients, config.max_clients))
  end
  
  -- Check diagnostics count
  for _, client in ipairs(clients) do
    for _, buf in ipairs(client.buffers) do
      if vim.api.nvim_buf_is_valid(buf) then
        local diagnostics = vim.diagnostic.get(buf)
        if #diagnostics > config.max_diagnostics_per_buffer then
          table.insert(issues, string.format("Buffer %d has %d diagnostics (max: %d)", 
            buf, #diagnostics, config.max_diagnostics_per_buffer))
        end
      end
    end
  end
  
  -- Store issues
  if #issues > 0 then
    stats.performance_issues = issues
    return false, issues
  end
  
  return true, {}
end

-- Show LSP status and resource usage
function M.status()
  local clients = get_active_clients()
  
  print("=== LSP Resource Status ===")
  print(string.format("Active clients: %d/%d", #clients, config.max_clients))
  print("")
  
  for _, client in ipairs(clients) do
    local diagnostics_count = 0
    for _, buf in ipairs(client.buffers) do
      if vim.api.nvim_buf_is_valid(buf) then
        diagnostics_count = diagnostics_count + #vim.diagnostic.get(buf)
      end
    end
    
    print(string.format("  %s:", client.name))
    print(string.format("    Buffers: %d", #client.buffers))
    print(string.format("    Diagnostics: %d", diagnostics_count))
    print(string.format("    Root: %s", client.root_dir or "unknown"))
  end
  
  print("")
  if #stats.performance_issues > 0 then
    print("⚠️  Performance Issues:")
    for _, issue in ipairs(stats.performance_issues) do
      print("  " .. issue)
    end
  else
    print("✅ No performance issues detected")
  end
end

-- Restart heavy LSP servers
function M.restart_heavy_servers()
  local heavy_servers = { "tsserver", "volar", "phpactor", "tailwindcss" }
  local restarted = {}
  local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
  
  for _, server_name in ipairs(heavy_servers) do
    for _, client in pairs(get_clients()) do
      if client.name == server_name then
        vim.cmd("LspRestart " .. server_name)
        table.insert(restarted, server_name)
        break
      end
    end
  end
  
  if #restarted > 0 then
    vim.notify("Restarted LSP servers: " .. table.concat(restarted, ", "), vim.log.levels.INFO)
  else
    vim.notify("No heavy LSP servers found to restart", vim.log.levels.WARN)
  end
end

-- Stop non-essential LSP servers
function M.stop_non_essential()
  local essential_servers = { "phpactor", "volar", "tsserver" }
  local stopped = {}
  local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
  
  for _, client in pairs(get_clients()) do
    if not vim.tbl_contains(essential_servers, client.name) then
      client.stop()
      table.insert(stopped, client.name)
    end
  end
  
  if #stopped > 0 then
    vim.notify("Stopped non-essential LSP servers: " .. table.concat(stopped, ", "), vim.log.levels.INFO)
  else
    vim.notify("Only essential LSP servers are running", vim.log.levels.INFO)
  end
end

-- Emergency stop all LSP servers
function M.emergency_stop()
  local stopped = {}
  local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
  for _, client in pairs(get_clients()) do
    client.stop()
    table.insert(stopped, client.name)
  end
  
  vim.notify("Emergency stop: Stopped all LSP servers (" .. #stopped .. ")", vim.log.levels.WARN)
end

-- Clean up excessive diagnostics
function M.clean_diagnostics()
  local cleaned_buffers = 0
  
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) then
      local diagnostics = vim.diagnostic.get(buf)
      if #diagnostics > config.max_diagnostics_per_buffer then
        -- Keep only errors and warnings, limit to max count
        local filtered = {}
        local count = 0
        
        for _, diag in ipairs(diagnostics) do
          if (diag.severity == vim.diagnostic.severity.ERROR or 
              diag.severity == vim.diagnostic.severity.WARN) and 
             count < config.max_diagnostics_per_buffer then
            table.insert(filtered, diag)
            count = count + 1
          end
        end
        
        vim.diagnostic.reset(nil, buf)
        vim.diagnostic.set(vim.api.nvim_create_namespace('lsp_control'), buf, filtered)
        cleaned_buffers = cleaned_buffers + 1
      end
    end
  end
  
  if cleaned_buffers > 0 then
    vim.notify(string.format("Cleaned diagnostics in %d buffers", cleaned_buffers), vim.log.levels.INFO)
  end
end

-- Toggle LSP for current buffer
function M.toggle_buffer_lsp()
  local buf = vim.api.nvim_get_current_buf()
  local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
  local clients = get_clients({ bufnr = buf })
  
  if #clients > 0 then
    -- Detach LSP from current buffer
    for _, client in ipairs(clients) do
      vim.lsp.buf_detach_client(buf, client.id)
    end
    vim.notify("LSP detached from current buffer", vim.log.levels.INFO)
  else
    -- Restart LSP for current buffer
    local filetype = vim.bo[buf].filetype
    if filetype ~= "" then
      vim.cmd("LspRestart")
      vim.notify("LSP restarted for current buffer", vim.log.levels.INFO)
    end
  end
end

-- Auto-monitor and optimize
local function auto_monitor()
  local ok, issues = M.check_resources()
  
  if not ok and #issues > 0 then
    -- Auto-clean diagnostics if too many
    for _, issue in ipairs(issues) do
      if issue:match("diagnostics") then
        M.clean_diagnostics()
        break
      end
    end
    
    -- Auto-stop non-essential servers if too many clients
    for _, issue in ipairs(issues) do
      if issue:match("Too many LSP clients") then
        M.stop_non_essential()
        break
      end
    end
  end
end

-- Setup commands and keybindings
function M.setup()
  -- Commands
  vim.api.nvim_create_user_command("LspStatus", M.status, 
    { desc = "Show LSP resource status" })
  
  vim.api.nvim_create_user_command("LspRestartHeavy", M.restart_heavy_servers, 
    { desc = "Restart heavy LSP servers" })
  
  vim.api.nvim_create_user_command("LspStopNonEssential", M.stop_non_essential, 
    { desc = "Stop non-essential LSP servers" })
  
  vim.api.nvim_create_user_command("LspEmergencyStop", M.emergency_stop, 
    { desc = "Emergency stop all LSP servers" })
  
  vim.api.nvim_create_user_command("LspCleanDiagnostics", M.clean_diagnostics, 
    { desc = "Clean excessive diagnostics" })
  
  vim.api.nvim_create_user_command("LspToggleBuffer", M.toggle_buffer_lsp, 
    { desc = "Toggle LSP for current buffer" })
  
  -- Keybindings
  vim.keymap.set("n", "<leader>ls", M.status, 
    { desc = "LSP status and resources" })
  vim.keymap.set("n", "<leader>lr", M.restart_heavy_servers, 
    { desc = "Restart heavy LSP servers" })
  vim.keymap.set("n", "<leader>lk", M.stop_non_essential, 
    { desc = "Stop non-essential LSP" })
  vim.keymap.set("n", "<leader>le", M.emergency_stop, 
    { desc = "Emergency stop all LSP" })
  vim.keymap.set("n", "<leader>lc", M.clean_diagnostics, 
    { desc = "Clean diagnostics" })
  vim.keymap.set("n", "<leader>lt", M.toggle_buffer_lsp, 
    { desc = "Toggle buffer LSP" })
  
  -- Auto-monitoring timer
  local timer = vim.loop.new_timer()
  if timer then
    timer:start(config.memory_check_interval, config.memory_check_interval, 
      vim.schedule_wrap(auto_monitor))
  end
  
  -- Auto-clean on diagnostics change
  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    callback = function()
      -- Debounced diagnostic cleaning
      vim.defer_fn(function()
        local ok, issues = M.check_resources()
        if not ok then
          for _, issue in ipairs(issues) do
            if issue:match("diagnostics") then
              M.clean_diagnostics()
              break
            end
          end
        end
      end, 1000)
    end,
  })
  
  -- Auto-optimization on LSP attach
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function()
      vim.defer_fn(function()
        local clients = get_active_clients()
        if #clients > config.max_clients then
          vim.notify("Too many LSP clients detected. Consider using :LspStopNonEssential", 
            vim.log.levels.WARN)
        end
      end, 2000)
    end,
  })
end

return M
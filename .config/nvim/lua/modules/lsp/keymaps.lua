-- LSP Configuration Module
-- Centralized LSP settings and keymaps

local M = {}

-- Default LSP capabilities with cmp integration
M.get_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end
  return capabilities
end

-- Global on_attach function for all LSP servers
M.on_attach = function(client, bufnr)
  -- Debug: notify when LSP attaches
  vim.notify("LSP attached: " .. client.name .. " to buffer " .. bufnr, vim.log.levels.INFO)
  
  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  -- LSP Keymaps (preserve existing shortcuts)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  
  vim.keymap.set("n", "<leader>lf", function()
    vim.lsp.buf.format({ async = true })
  end, vim.tbl_extend("force", opts, { desc = "Format Code" }))

  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, 
    vim.tbl_extend("force", opts, { desc = "Code Action" }))

  vim.keymap.set("n", "K", vim.lsp.buf.hover, 
    vim.tbl_extend("force", opts, { desc = "Hover Documentation" }))
  
  vim.keymap.set("n", "<leader>gd", function()
    local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
    local clients = get_clients({ bufnr = bufnr })
    if #clients == 0 then
      vim.notify("No LSP clients attached to this buffer", vim.log.levels.WARN)
      return
    end
    
    vim.notify(string.format("Go to Definition (clients: %s)", 
      table.concat(vim.tbl_map(function(c) return c.name end, clients), ", ")), 
      vim.log.levels.INFO)
    
    vim.lsp.buf.definition()
  end, vim.tbl_extend("force", opts, { desc = "Go to Definition" }))
  
  vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, 
    vim.tbl_extend("force", opts, { desc = "Find References" }))
  
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, 
    vim.tbl_extend("force", opts, { desc = "Rename Symbol" }))
  
  vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, 
    vim.tbl_extend("force", opts, { desc = "Go to Implementation" }))
  
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, 
    vim.tbl_extend("force", opts, { desc = "Previous Diagnostic" }))
  
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, 
    vim.tbl_extend("force", opts, { desc = "Next Diagnostic" }))
  
  vim.keymap.set("n", "<leader>ld", function() 
    vim.diagnostic.setloclist()
  end, vim.tbl_extend("force", opts, { desc = "List Diagnostics" }))
end

-- Diagnostic configuration - Optimized for performance
M.diagnostic_config = {
  virtual_text = {
    prefix = '●',
    source = false, -- Disable source to reduce text length
    spacing = 2, -- Reduce spacing
    severity = { min = vim.diagnostic.severity.WARN }, -- Only show warnings and errors
    format = function(diagnostic)
      local message = diagnostic.message
      local max_length = 30 -- Shorter messages
      if #message > max_length then
        message = message:sub(1, max_length) .. "..."
      end
      return message -- Remove severity prefix to save space
    end,
  },
  signs = {
    severity = { min = vim.diagnostic.severity.WARN }, -- Only show warning+ signs
  },
  underline = {
    severity = { min = vim.diagnostic.severity.ERROR }, -- Only underline errors
  },
  update_in_insert = false, -- Never update in insert mode
  -- Performance optimizations
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many", -- Only show source when multiple
    header = "",
    prefix = "",
    max_width = 60, -- Smaller float windows
    max_height = 15,
    focusable = false, -- Prevent focus to reduce overhead
  },
}

-- Diagnostic signs
M.diagnostic_signs = { 
  Error = "󰅚 ", 
  Warn = "󰀪 ", 
  Hint = "󰌶 ", 
  Info = " " 
}

-- Configure diagnostics
M.setup_diagnostics = function()
  vim.diagnostic.config(M.diagnostic_config)
  
  -- Set diagnostic signs
  for type, icon in pairs(M.diagnostic_signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
  
  -- Create toggle command
  local virtual_text_enabled = true
  vim.api.nvim_create_user_command("ToggleDiagnosticVirtualText", function()
    virtual_text_enabled = not virtual_text_enabled
    if virtual_text_enabled then
      vim.diagnostic.config({ virtual_text = M.diagnostic_config.virtual_text })
      vim.notify("Diagnostic virtual text enabled", vim.log.levels.INFO)
    else
      vim.diagnostic.config({ virtual_text = false })
      vim.notify("Diagnostic virtual text disabled", vim.log.levels.INFO)
    end
  end, { desc = "Toggle diagnostic virtual text" })
  
  -- Keybinding for toggle (keeping existing shortcut from CLAUDE.md)
  vim.keymap.set("n", "<leader>dv", ":ToggleDiagnosticVirtualText<CR>", 
    { noremap = true, silent = true, desc = "Toggle Diagnostic Text" })
    
  -- Command to show full diagnostic message
  vim.api.nvim_create_user_command("DiagnosticFull", function()
    local line_diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
    if #line_diagnostics == 0 then
      vim.notify("No diagnostics on current line", vim.log.levels.INFO)
      return
    end
    
    -- Create a floating window with full diagnostic info
    local lines = {}
    for i, diagnostic in ipairs(line_diagnostics) do
      table.insert(lines, string.format("=== Diagnostic %d ===", i))
      table.insert(lines, "")
      
      -- Add severity
      local severity = vim.diagnostic.severity[diagnostic.severity]
      table.insert(lines, "Severity: " .. severity)
      
      -- Add source if available
      if diagnostic.source then
        table.insert(lines, "Source: " .. diagnostic.source)
      end
      
      -- Add code if available
      if diagnostic.code then
        table.insert(lines, "Code: " .. tostring(diagnostic.code))
      end
      
      table.insert(lines, "")
      table.insert(lines, "Message:")
      
      -- Word wrap the message for readability
      local message = diagnostic.message
      local max_width = 80
      while #message > 0 do
        local line = message:sub(1, max_width)
        local last_space = line:find(" [^ ]*$")
        if last_space and #message > max_width then
          line = message:sub(1, last_space - 1)
          message = message:sub(last_space + 1)
        else
          message = message:sub(#line + 1)
        end
        table.insert(lines, "  " .. line)
      end
      
      if i < #line_diagnostics then
        table.insert(lines, "")
        table.insert(lines, "---")
        table.insert(lines, "")
      end
    end
    
    -- Create floating window
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    
    local width = math.min(100, vim.o.columns - 4)
    local height = math.min(#lines, vim.o.lines - 4)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)
    
    local win = vim.api.nvim_open_win(buf, true, {
      relative = 'editor',
      width = width,
      height = height,
      row = row,
      col = col,
      style = 'minimal',
      border = 'rounded',
      title = ' Full Diagnostics ',
      title_pos = 'center',
    })
    
    -- Set buffer keymaps for easy closing
    local close_keys = {'<Esc>', 'q', '<CR>'}
    for _, key in ipairs(close_keys) do
      vim.api.nvim_buf_set_keymap(buf, 'n', key, ':close<CR>', 
        { noremap = true, silent = true })
    end
    
    -- Syntax highlighting for better readability
    vim.api.nvim_win_set_option(win, 'wrap', true)
    vim.cmd('syntax match DiagnosticFullHeader /^=== Diagnostic .* ===$/') 
    vim.cmd('syntax match DiagnosticFullLabel /^\\(Severity\\|Source\\|Code\\|Message\\):/') 
    vim.cmd('hi link DiagnosticFullHeader Title')
    vim.cmd('hi link DiagnosticFullLabel Label')
  end, { desc = "Show full diagnostic message for current line" })
  
  -- Global keybinding for full diagnostic
  vim.keymap.set("n", "<leader>gl", ":DiagnosticFull<CR>", 
    { noremap = true, silent = true, desc = "Show Full Diagnostic" })
end

return M
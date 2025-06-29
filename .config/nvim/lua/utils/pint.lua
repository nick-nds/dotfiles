-- Laravel Pint configurator
local M = {}

-- Create a default Pint configuration file for a Laravel project
M.create_default_config = function()
  local pint_config = {
    preset = "laravel",
    rules = {
      -- Align phpdoc params
      "align_phpdoc",
      -- Use short forms of type keywords (bool instead of boolean)
      "short_scalar_cast",
      -- Variables should be camelCase
      "standardize_not_equals",
      -- Add missing parameter and return types where possible
      "declare_strict_types" -- Requires PHP 7.0+
    }
  }
  
  -- Convert to JSON
  local json = vim.fn.json_encode(pint_config)
  
  -- Format the JSON to make it more readable
  local formatted_json = vim.fn.system("echo '" .. json .. "' | python3 -m json.tool")
  
  -- Create pint.json in the current directory
  local file = io.open("pint.json", "w")
  if file then
    file:write(formatted_json)
    file:close()
    print("Created pint.json in the current directory")
  else
    print("Failed to create pint.json")
  end
end

-- Add a file header template to an existing Pint config
M.add_file_header = function(header_text)
  -- Default header if none provided
  header_text = header_text or [[
This file is part of the application.

(c) Your Name <your.email@example.com>

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
]]

  -- Try to read the existing pint.json
  local file = io.open("pint.json", "r")
  if not file then
    print("pint.json not found. Creating a new one with header...")
    local pint_config = {
      preset = "laravel",
      rules = {
        header_comment = {
          comment_type = "PHPDoc",
          header = header_text,
          location = "after_open"
        }
      }
    }
    
    -- Convert to JSON and write
    local json = vim.fn.json_encode(pint_config)
    local formatted_json = vim.fn.system("echo '" .. json .. "' | python3 -m json.tool")
    
    file = io.open("pint.json", "w")
    if file then
      file:write(formatted_json)
      file:close()
      print("Created pint.json with file header configuration")
    else
      print("Failed to create pint.json")
    end
    return
  end
  
  -- Read existing config
  local content = file:read("*all")
  file:close()
  
  -- Parse the JSON
  local success, pint_config = pcall(vim.fn.json_decode, content)
  if not success then
    print("Failed to parse pint.json. Is it valid JSON?")
    return
  end
  
  -- Add or update the header_comment rule
  pint_config.rules = pint_config.rules or {}
  pint_config.rules.header_comment = {
    comment_type = "PHPDoc",
    header = header_text,
    location = "after_open"
  }
  
  -- Convert back to JSON and write
  local json = vim.fn.json_encode(pint_config)
  local formatted_json = vim.fn.system("echo '" .. json .. "' | python3 -m json.tool")
  
  file = io.open("pint.json", "w")
  if file then
    file:write(formatted_json)
    file:close()
    print("Updated pint.json with file header configuration")
  else
    print("Failed to update pint.json")
  end
end

-- Command to run Pint on current file
vim.api.nvim_create_user_command("PintFormat", function()
  vim.cmd("write") -- Save the file first
  local filepath = vim.fn.expand("%:p")
  
  -- Run Pint on the current file
  local result = vim.fn.system("pint " .. filepath)
  
  -- Reload the file to show changes
  vim.cmd("edit!")
  
  -- Show the result
  print("Pint: " .. result:gsub("[\r\n]", " "))
end, {})

-- Add PHP-specific keybinding for Pint
vim.api.nvim_create_autocmd("FileType", {
  pattern = "php",
  callback = function()
    vim.keymap.set("n", "<leader>pf", ":PintFormat<CR>", 
                  { noremap = true, silent = true, buffer = true, desc = "Format with Pint" })
    vim.keymap.set("n", "<leader>pa", ":PintFormatProject<CR>", 
                  { noremap = true, silent = true, buffer = true, desc = "Format all with Pint" })
  end
})

-- Command to run Pint on the entire project
vim.api.nvim_create_user_command("PintFormatProject", function()
  -- Save all buffers first
  vim.cmd("wall")
  
  -- Run Pint on all PHP files
  local result = vim.fn.system("pint")
  
  -- Reload all buffers
  vim.cmd("checktime")
  
  -- Show the result
  print("Pint: " .. result:gsub("[\r\n]", " "))
end, {})

-- Command to create default Pint config
vim.api.nvim_create_user_command("PintCreateConfig", function()
  M.create_default_config()
end, {})

-- Command to add file header to Pint config
vim.api.nvim_create_user_command("PintAddFileHeader", function()
  -- Prompt the user for a custom header
  vim.ui.input({
    prompt = "Enter file header text (leave empty for default): ",
  }, function(input)
    if input then
      M.add_file_header(input ~= "" and input or nil)
    end
  end)
end, {})

return M
-- Laravel testing utilities for system PHP and Docker
local M = {}

-- Check if we're in a Laravel project
function M.is_laravel_project()
  return vim.fn.filereadable("artisan") == 1 and vim.fn.filereadable("composer.json") == 1
end

-- Check if Docker Compose is available
function M.is_docker_available()
  return vim.fn.executable("docker") == 1 and vim.fn.filereadable("docker-compose.yml") == 1
end

-- Get COMPOSE_PROJECT from .env file
function M.get_compose_project()
  if not vim.fn.filereadable(".env") then
    return nil
  end
  
  local env_content = vim.fn.readfile(".env")
  for _, line in ipairs(env_content) do
    local project = line:match("^COMPOSE_PROJECT=(.+)")
    if project then
      return project:gsub('"', ''):gsub("'", '') -- Remove quotes if present
    end
  end
  return nil
end

-- Get Docker container name for PHP
function M.get_php_container()
  local compose_project = M.get_compose_project()
  if compose_project then
    return compose_project .. "-php-fpm-debug"
  end
  return nil
end

-- Check if Docker container is running
function M.is_container_running(container_name)
  if not container_name then
    return false
  end
  
  local handle = io.popen("docker ps --format '{{.Names}}' | grep '^" .. container_name .. "$'")
  local result = handle:read("*a")
  handle:close()
  
  return result:match(container_name) ~= nil
end

-- Check if artisan alias is available (preferred method)
function M.is_artisan_available()
  return vim.fn.executable("artisan") == 1
end

-- Check if PHPUnit is available (artisan alias, system or container)
function M.is_phpunit_available()
  -- First check if artisan alias is available (preferred)
  if M.is_artisan_available() then
    return true -- If artisan alias works, PHPUnit should be available too
  end
  
  -- Check if Docker is available and container is running
  if M.is_docker_available() then
    local container = M.get_php_container()
    if container and M.is_container_running(container) then
      return true -- Assume PHPUnit is available in Laravel container
    end
  end
  
  -- Fallback to system PHPUnit
  return vim.fn.filereadable("vendor/bin/phpunit") == 1 or vim.fn.executable("phpunit") == 1
end

-- Get PHPUnit command (artisan alias, Docker or system)
function M.get_phpunit_cmd()
  -- First try artisan alias (most robust) - use Laravel's built-in test command
  if M.is_artisan_available() then
    return "artisan test"
  end
  
  -- Try Docker if available
  if M.is_docker_available() then
    local container = M.get_php_container()
    if container and M.is_container_running(container) then
      return "docker exec " .. container .. " vendor/bin/phpunit"
    end
  end
  
  -- Fallback to system PHPUnit
  if vim.fn.filereadable("vendor/bin/phpunit") == 1 then
    return "./vendor/bin/phpunit"
  elseif vim.fn.executable("phpunit") == 1 then
    return "phpunit"
  else
    return nil
  end
end

-- Get execution environment info
function M.get_env_info()
  if M.is_artisan_available() then
    return "🚀 Artisan Alias"
  elseif M.is_docker_available() then
    local container = M.get_php_container()
    if container and M.is_container_running(container) then
      return "🐳 Docker (" .. container .. ")"
    end
  end
  return "🖥️  System PHP"
end

-- Extract test method name at current line
function M.get_test_method_at_line()
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  
  -- Search backwards from current line to find test method
  for i = current_line, 1, -1 do
    local line = lines[i]
    if line then
      -- Look for test method pattern
      local method = line:match("function%s+(test%w+)")
      if method then
        return method
      end
      -- Also check for PHPUnit annotations
      if line:match("@test") then
        -- Find the next function
        for j = i, #lines do
          local next_line = lines[j]
          if next_line then
            local next_method = next_line:match("function%s+(%w+)")
            if next_method then
              return next_method
            end
          end
        end
      end
    end
  end
  
  return nil
end

-- Get the appropriate test command
function M.get_test_command(test_type)
  local phpunit_cmd = M.get_phpunit_cmd()
  if not phpunit_cmd then
    vim.notify("PHPUnit not found. Please install it via Composer or globally.", vim.log.levels.ERROR)
    return nil
  end
  
  local is_artisan_test = phpunit_cmd:match("artisan test")
  
  if test_type == "nearest" then
    -- Run the test nearest to cursor
    local current_file = vim.api.nvim_buf_get_name(0)
    local relative_path = vim.fn.fnamemodify(current_file, ":.")
    local test_method = M.get_test_method_at_line()
    
    if test_method then
      if is_artisan_test then
        return string.format("%s --filter=%s %s", phpunit_cmd, test_method, relative_path)
      else
        return string.format("%s --filter=%s %s", phpunit_cmd, test_method, relative_path)
      end
    else
      vim.notify("No test method found at cursor position", vim.log.levels.WARN)
      if is_artisan_test then
        return string.format("%s %s", phpunit_cmd, relative_path)
      else
        return string.format("%s %s", phpunit_cmd, relative_path)
      end
    end
  elseif test_type == "file" then
    local current_file = vim.api.nvim_buf_get_name(0)
    local relative_path = vim.fn.fnamemodify(current_file, ":.")
    return string.format("%s %s", phpunit_cmd, relative_path)
  elseif test_type == "all" then
    return phpunit_cmd
  elseif test_type == "unit" then
    if is_artisan_test then
      return string.format("%s --testsuite=Unit", phpunit_cmd)
    else
      return string.format("%s tests/Unit", phpunit_cmd)
    end
  elseif test_type == "feature" then
    if is_artisan_test then
      return string.format("%s --testsuite=Feature", phpunit_cmd)
    else
      return string.format("%s tests/Feature", phpunit_cmd)
    end
  end
  
  return nil
end

-- Run test command in terminal
function M.run_test(command)
  if not command then
    vim.notify("No test command generated", vim.log.levels.ERROR)
    return
  end
  
  -- Save current file if modified
  if vim.bo.modified then
    vim.cmd("write")
  end
  
  -- Check if we're using artisan and suggest environment setup
  if command:match("artisan test") then
    vim.notify("Running " .. M.get_env_info() .. ": " .. command .. " (with Docker database)", vim.log.levels.INFO)
  else
    vim.notify("Running " .. M.get_env_info() .. ": " .. command, vim.log.levels.INFO)
  end
  
  -- Run in toggleterm if available, otherwise use terminal split
  local has_toggleterm, toggleterm = pcall(require, "toggleterm.terminal")
  if has_toggleterm then
    local Terminal = toggleterm.Terminal
    local test_terminal = Terminal:new({
      direction = "horizontal",
      size = 15,
      close_on_exit = false,
      on_open = function(term)
        -- Set up better keymaps for the terminal
        local opts = { buffer = term.bufnr, noremap = true, silent = true }
        -- Escape to normal mode
        vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', opts)
        -- Easy close
        vim.keymap.set('n', 'q', '<cmd>close<cr>', opts)
        vim.keymap.set('n', '<leader>q', '<cmd>close<cr>', opts)
        
        -- Send the command to the terminal after it opens
        vim.defer_fn(function()
          if vim.api.nvim_buf_is_valid(term.bufnr) then
            term:send(command)
          end
        end, 100)
      end,
      on_close = function()
        vim.notify("Test execution completed", vim.log.levels.INFO)
      end,
    })
    test_terminal:toggle()
  else
    -- Fallback: open a normal terminal and send the command
    vim.cmd("split")
    vim.cmd("resize 15")
    vim.cmd("terminal")
    
    -- Send the command to the terminal
    vim.defer_fn(function()
      local keys = vim.api.nvim_replace_termcodes(command .. "<CR>", true, false, true)
      vim.api.nvim_feedkeys(keys, "t", false)
    end, 200)
    
    -- Set up terminal keymaps
    local term_buf = vim.api.nvim_get_current_buf()
    local opts = { buffer = term_buf, noremap = true, silent = true }
    -- Escape to normal mode  
    vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', opts)
    -- Easy close
    vim.keymap.set('n', 'q', '<cmd>close<cr>', opts)
    vim.keymap.set('n', '<leader>q', '<cmd>close<cr>', opts)
  end
end

-- Setup keymaps for Laravel testing
function M.setup_keymaps()
  local opts = { noremap = true, silent = true }
  
  -- Only set up keymaps if we're in a Laravel project
  vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
    pattern = {"*.php"},
    callback = function()
      if M.is_laravel_project() then
        -- Test keymaps (buffer-local)
        local buffer_opts = vim.tbl_extend('force', opts, { buffer = true })
        
        vim.keymap.set('n', '<leader>tt', function()
          -- Use Neotest for better integration
          local neotest_ok, neotest = pcall(require, "neotest")
          if neotest_ok then
            neotest.run.run()
          else
            -- Fallback to custom testing
            if not M.is_phpunit_available() then
              if not M.is_artisan_available() then
                vim.notify("Artisan alias not found. Set up your 'artisan' alias or run 'composer install' for system PHP.", vim.log.levels.ERROR)
              else
                local container = M.get_php_container()
                if container then
                  vim.notify("Docker container '" .. container .. "' not running. Start with 'docker-compose up'.", vim.log.levels.ERROR)
                else
                  vim.notify("PHPUnit not available. Run 'composer install' or install PHPUnit globally.", vim.log.levels.ERROR)
                end
              end
              return
            end
            local cmd = M.get_test_command("nearest")
            M.run_test(cmd)
          end
        end, vim.tbl_extend('force', buffer_opts, { desc = 'Run nearest test' }))
        
        vim.keymap.set('n', '<leader>tf', function()
          local neotest_ok, neotest = pcall(require, "neotest")
          if neotest_ok then
            neotest.run.run(vim.fn.expand("%"))
          else
            -- Fallback to custom testing
            if not M.is_phpunit_available() then
              if not M.is_artisan_available() then
                vim.notify("Artisan alias not found. Set up your 'artisan' alias or run 'composer install' for system PHP.", vim.log.levels.ERROR)
              else
                local container = M.get_php_container()
                if container then
                  vim.notify("Docker container '" .. container .. "' not running. Start with 'docker-compose up'.", vim.log.levels.ERROR)
                else
                  vim.notify("PHPUnit not available. Run 'composer install' or install PHPUnit globally.", vim.log.levels.ERROR)
                end
              end
              return
            end
            local cmd = M.get_test_command("file")
            M.run_test(cmd)
          end
        end, vim.tbl_extend('force', buffer_opts, { desc = 'Run current file tests' }))
        
        vim.keymap.set('n', '<leader>ta', function()
          local neotest_ok, neotest = pcall(require, "neotest")
          if neotest_ok then
            neotest.run.run(vim.fn.getcwd())
          else
            -- Fallback to custom testing
            if not M.is_phpunit_available() then
              if not M.is_artisan_available() then
                vim.notify("Artisan alias not found. Set up your 'artisan' alias or run 'composer install' for system PHP.", vim.log.levels.ERROR)
              else
                local container = M.get_php_container()
                if container then
                  vim.notify("Docker container '" .. container .. "' not running. Start with 'docker-compose up'.", vim.log.levels.ERROR)
                else
                  vim.notify("PHPUnit not available. Run 'composer install' or install PHPUnit globally.", vim.log.levels.ERROR)
                end
              end
              return
            end
            local cmd = M.get_test_command("all")
            M.run_test(cmd)
          end
        end, vim.tbl_extend('force', buffer_opts, { desc = 'Run all tests' }))
        
        vim.keymap.set('n', '<leader>tu', function()
          if not M.is_phpunit_available() then
            if not M.is_artisan_available() then
              vim.notify("Artisan alias not found. Set up your 'artisan' alias or run 'composer install' for system PHP.", vim.log.levels.ERROR)
            else
              local container = M.get_php_container()
              if container then
                vim.notify("Docker container '" .. container .. "' not running. Start with 'docker-compose up'.", vim.log.levels.ERROR)
              else
                vim.notify("PHPUnit not available. Run 'composer install' or install PHPUnit globally.", vim.log.levels.ERROR)
              end
            end
            return
          end
          local cmd = M.get_test_command("unit")
          M.run_test(cmd)
        end, vim.tbl_extend('force', buffer_opts, { desc = 'Run unit tests' }))
        
        vim.keymap.set('n', '<leader>tF', function()
          if not M.is_phpunit_available() then
            if not M.is_artisan_available() then
              vim.notify("Artisan alias not found. Set up your 'artisan' alias or run 'composer install' for system PHP.", vim.log.levels.ERROR)
            else
              local container = M.get_php_container()
              if container then
                vim.notify("Docker container '" .. container .. "' not running. Start with 'docker-compose up'.", vim.log.levels.ERROR)
              else
                vim.notify("PHPUnit not available. Run 'composer install' or install PHPUnit globally.", vim.log.levels.ERROR)
              end
            end
            return
          end
          local cmd = M.get_test_command("feature")
          M.run_test(cmd)
        end, vim.tbl_extend('force', buffer_opts, { desc = 'Run feature tests' }))
        
        -- Show test output/results
        vim.keymap.set('n', '<leader>tr', function()
          local neotest_ok, neotest = pcall(require, "neotest")
          if neotest_ok then
            neotest.output.open({ enter = true })
          else
            -- Fallback: Find terminal buffer and focus it
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.bo[buf].buftype == 'terminal' then
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                  if vim.api.nvim_win_get_buf(win) == buf then
                    vim.api.nvim_set_current_win(win)
                    vim.cmd("normal! G") -- Go to bottom
                    return
                  end
                end
              end
            end
            vim.notify("No test results found", vim.log.levels.WARN)
          end
        end, vim.tbl_extend('force', buffer_opts, { desc = 'Show test results' }))
        
        -- Test summary
        vim.keymap.set('n', '<leader>ts', function()
          local neotest_ok, neotest = pcall(require, "neotest")
          if neotest_ok then
            neotest.summary.toggle()
          else
            vim.notify("Neotest not available", vim.log.levels.WARN)
          end
        end, vim.tbl_extend('force', buffer_opts, { desc = 'Toggle test summary' }))
        
        -- Test output panel
        vim.keymap.set('n', '<leader>to', function()
          local neotest_ok, neotest = pcall(require, "neotest")
          if neotest_ok then
            neotest.output_panel.toggle()
          else
            vim.notify("Neotest not available", vim.log.levels.WARN)
          end
        end, vim.tbl_extend('force', buffer_opts, { desc = 'Toggle test output panel' }))
      end
    end,
  })
end

-- Commands
vim.api.nvim_create_user_command('TestNearest', function()
  local cmd = M.get_test_command("nearest")
  M.run_test(cmd)
end, { desc = 'Run nearest test' })

vim.api.nvim_create_user_command('TestFile', function()
  local cmd = M.get_test_command("file")
  M.run_test(cmd)
end, { desc = 'Run current file tests' })

vim.api.nvim_create_user_command('TestAll', function()
  local cmd = M.get_test_command("all")
  M.run_test(cmd)
end, { desc = 'Run all tests' })

vim.api.nvim_create_user_command('TestStatus', function()
  print("=== Laravel Testing Status ===")
  print("Laravel Project: " .. (M.is_laravel_project() and "✅ Yes" or "❌ No"))
  print("Artisan Alias: " .. (M.is_artisan_available() and "✅ Available" or "❌ Not found"))
  print("Docker Available: " .. (M.is_docker_available() and "✅ Yes" or "❌ No"))
  
  local compose_project = M.get_compose_project()
  print("COMPOSE_PROJECT: " .. (compose_project or "❌ Not set"))
  
  local container = M.get_php_container()
  if container then
    print("PHP Container: " .. container)
    print("Container Running: " .. (M.is_container_running(container) and "✅ Yes" or "❌ No"))
  end
  
  print("Environment: " .. M.get_env_info())
  print("PHPUnit Available: " .. (M.is_phpunit_available() and "✅ Yes" or "❌ No"))
  
  local cmd = M.get_phpunit_cmd()
  if cmd then
    print("Test Command: " .. cmd)
  end
  
  -- Additional database troubleshooting info
  if M.is_artisan_available() then
    print("\n=== Database Connection Tips ===")
    print("If getting PDO driver errors:")
    print("1. Ensure database containers are running: docker-compose up -d")
    print("2. Check test database config in .env.testing or phpunit.xml")
    print("3. Try: artisan migrate --env=testing")
    print("4. Try: artisan config:clear && artisan test")
  end
end, { desc = 'Show Laravel testing setup status' })

-- Add database preparation commands
vim.api.nvim_create_user_command('TestPrepareDB', function()
  if M.is_artisan_available() then
    vim.notify("Preparing test database...", vim.log.levels.INFO)
    local cmd = "artisan migrate --env=testing --force"
    M.run_test(cmd)
  else
    vim.notify("Artisan alias not available", vim.log.levels.ERROR)
  end
end, { desc = 'Prepare test database with migrations' })

vim.api.nvim_create_user_command('TestRefreshDB', function()
  if M.is_artisan_available() then
    vim.notify("Refreshing test database...", vim.log.levels.INFO)
    local cmd = "artisan migrate:refresh --env=testing --force --seed"
    M.run_test(cmd)
  else
    vim.notify("Artisan alias not available", vim.log.levels.ERROR)
  end
end, { desc = 'Refresh test database with migrations and seeds' })

-- Alternative command that loads full shell environment
vim.api.nvim_create_user_command('TestNearestShell', function()
  if not M.is_laravel_project() then
    vim.notify("Not in a Laravel project", vim.log.levels.WARN)
    return
  end
  
  -- Use interactive shell to ensure all aliases and env vars are loaded
  local current_file = vim.api.nvim_buf_get_name(0)
  local relative_path = vim.fn.fnamemodify(current_file, ":.")
  local test_method = M.get_test_method_at_line()
  
  local shell_cmd
  if test_method then
    shell_cmd = string.format("bash -i -c 'artisan test --filter=%s %s'", test_method, relative_path)
  else
    shell_cmd = string.format("bash -i -c 'artisan test %s'", relative_path)
  end
  
  vim.notify("Running with interactive shell: " .. shell_cmd, vim.log.levels.INFO)
  M.run_test(shell_cmd)
end, { desc = 'Run nearest test with interactive shell (loads full environment)' })

return M
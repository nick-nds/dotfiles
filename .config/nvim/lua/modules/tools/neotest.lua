return {
  "nvim-neotest/neotest",
  enabled = true, -- Re-enable for testing integration
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "olimorris/neotest-phpunit",
    "marilari88/neotest-vitest",
    "haydenmeade/neotest-jest",
  },
  config = function()
    -- Helper function to check if artisan alias is available
    local function is_artisan_available()
      return vim.fn.executable("artisan") == 1
    end
    
    -- Helper function to get compose project from .env
    local function get_compose_project()
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
    
    -- Helper function to check if Docker container is running
    local function is_container_running(container_name)
      if not container_name then
        return false
      end
      
      local handle = io.popen("docker ps --format '{{.Names}}' | grep '^" .. container_name .. "$'")
      local result = handle:read("*a")
      handle:close()
      
      return result:match(container_name) ~= nil
    end

    require("neotest").setup({
      adapters = {
        -- PHPUnit adapter with smart command detection
        require("neotest-phpunit")({
          phpunit_cmd = function()
            -- First try artisan alias (preferred)
            if is_artisan_available() then
              -- Use artisan test command with shell wrapper to ensure alias works
              return function(args)
                local cmd = {"bash", "-c", "artisan test " .. table.concat(args, " ")}
                return cmd
              end
            end
            
            -- Fallback to Docker container detection
            local compose_project = get_compose_project()
            if compose_project then
              local container = compose_project .. "-php-fpm-debug"
              if is_container_running(container) then
                return "docker exec " .. container .. " vendor/bin/phpunit"
              end
            end
            
            -- Final fallback to local PHPUnit
            if vim.fn.filereadable("vendor/bin/phpunit") == 1 then
              return "./vendor/bin/phpunit"
            end
            
            vim.notify("No PHPUnit command available for Neotest", vim.log.levels.ERROR)
            return nil
          end,
          env = {
            -- Ensure we're using the testing environment
            APP_ENV = "testing",
          },
          root_files = { "composer.json", "phpunit.xml", "phpunit.xml.dist" },
        }),
        
        -- Vitest adapter for containerized Node.js projects
        require("neotest-vitest")({
          vitestCommand = function()
            local testing = require('testing')
            
            -- Validate containers first
            local containers_ok, container_msg = testing.validate_containers()
            if not containers_ok then
              vim.notify("Neotest Container Error: " .. container_msg, vim.log.levels.ERROR)
              return nil
            end
            
            local service = testing.find_service_name("node")
            if service then
              return "docker compose exec -T " .. service .. " npx vitest"
            else
              vim.notify("No Node.js service found for Neotest Vitest", vim.log.levels.ERROR)
              return nil
            end
          end,
        }),
        
        -- Jest adapter for containerized Node.js projects  
        require("neotest-jest")({
          jestCommand = function()
            local testing = require('testing')
            
            -- Validate containers first
            local containers_ok, container_msg = testing.validate_containers()
            if not containers_ok then
              vim.notify("Neotest Container Error: " .. container_msg, vim.log.levels.ERROR)
              return nil
            end
            
            local service = testing.find_service_name("node")
            if service then
              return "docker compose exec -T " .. service .. " npx jest"
            else
              vim.notify("No Node.js service found for Neotest Jest", vim.log.levels.ERROR)
              return nil
            end
          end,
        }),
      },
      
      -- Enhanced output and status
      output = {
        enabled = true,
        open_on_run = false,
      },
      
      status = {
        enabled = true,
        signs = true,
        virtual_text = true,
      },
      
      -- Configure status and output display
      status = {
        enabled = true,
        virtual_text = true,
        signs = true,
      },
      
      output = {
        enabled = true,
        open_on_run = "short", -- Only open output for short tests that fail
      },
      
      -- Run configuration
      run = {
        enabled = true,
      },
      
      -- Discovery settings for containerized projects
      discovery = {
        enabled = true,
        concurrent = 0, -- Disable concurrent discovery for Docker
      },
    })
  end,
  
  keys = {
    -- Neotest specific keybindings (complement our custom framework)
    { "<leader>nt", function() require("neotest").run.run() end, desc = "Run nearest test (neotest)" },
    { "<leader>nf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file tests (neotest)" },
    { "<leader>na", function() require("neotest").run.run(vim.fn.getcwd()) end, desc = "Run all tests (neotest)" },
    { "<leader>ns", function() require("neotest").summary.toggle() end, desc = "Toggle test summary" },
    { "<leader>no", function() require("neotest").output.open({ enter = true }) end, desc = "Open test output" },
    { "<leader>np", function() require("neotest").output_panel.toggle() end, desc = "Toggle output panel" },
  }
}

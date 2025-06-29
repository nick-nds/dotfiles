return {
  -- nvim-lspconfig: Core LSP configuration
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    priority = 100, -- Load early
  },
  
  -- Mason: Install LSPs, linters, and formatters - Optimized
  {
    "williamboman/mason.nvim",
    lazy = false, -- Essential for LSP
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
    },
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜", 
            package_uninstalled = "✗",
          },
          border = "rounded",
          width = 0.8,
          height = 0.8,
        },
        -- Performance optimizations
        install_root_dir = vim.fn.stdpath("data") .. "/mason",
        pip = {
          upgrade_pip = false, -- Don't auto-upgrade pip
        },
        log_level = vim.log.levels.WARN, -- Reduce log verbosity
        max_concurrent_installers = 2, -- Limit concurrent installations to reduce system load
      })
    end,
  },

  -- Mason LSP Config: Bridges Mason with Neovim's LSP - Optimized
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false, -- Ensure LSP loads immediately
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      local servers_config = require("modules.lsp.servers")
      local lsp_config = require("modules.lsp.keymaps")
      
      require("mason-lspconfig").setup({
        ensure_installed = servers_config.servers,
        automatic_installation = false, -- Disable auto-installation to prevent resource spikes
        handlers = {
          -- Default handler with resource limits
          function(server_name)
            -- Handle Mason package name to lspconfig server name mapping
            local lspconfig_name = server_name
            if server_name == "vue-language-server" then
              lspconfig_name = "volar"
            elseif server_name == "typescript-language-server" then
              lspconfig_name = "tsserver" 
            end
            
            local server_config = servers_config.server_configs[lspconfig_name] or {}
            local lspconfig = require("lspconfig")
            
            -- Add global resource optimizations
            local base_config = {
              capabilities = lsp_config.get_capabilities(),
              on_attach = lsp_config.on_attach, -- Default on_attach
              flags = {
                debounce_text_changes = 500, -- Increased debounce for performance
                allow_incremental_sync = true,
                exit_timeout = 5000, -- Faster shutdown
              },
              -- Add memory limits where possible
              cmd_env = {
                NODE_OPTIONS = "--max-old-space-size=512", -- Limit Node.js memory to 512MB
              },
            }
            
            -- If server has custom on_attach, wrap it to ensure keymaps are set
            if server_config.on_attach then
              local custom_on_attach = server_config.on_attach
              server_config.on_attach = function(client, bufnr)
                -- Call the custom on_attach (which should call lsp_config.on_attach)
                custom_on_attach(client, bufnr)
              end
            end
            
            local optimized_config = vim.tbl_deep_extend("force", base_config, server_config)
            
            local ok, err = pcall(function()
              lspconfig[lspconfig_name].setup(optimized_config)
            end)
            
            if not ok then
              vim.notify("Failed to setup LSP server: " .. lspconfig_name .. " - " .. tostring(err), vim.log.levels.WARN)
            end
          end,
        }
      })
      
      -- Setup diagnostics
      lsp_config.setup_diagnostics()
    end,
  },

  -- SchemaStore for JSON schemas
  {
    "b0o/schemastore.nvim", 
    lazy = true
  },

  -- Null-ls: Formatters, linters, and code actions
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")
      local formatting_config = require("modules.lsp.formatting")
      
      -- Get all configured sources
      local sources = formatting_config.get_sources(null_ls)
      
      -- Setup null-ls with collected sources
      null_ls.setup({
        debug = false,
        sources = sources,
      })
    end,
  },

  -- Mason Null-ls: Manage formatters & linters via Mason
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls.nvim" },
    config = function()
      local formatting_config = require("modules.lsp.formatting")
      
      require("mason-null-ls").setup({
        ensure_installed = formatting_config.ensure_installed,
        automatic_installation = true,
        handlers = {},
      })
    end,
  },

  -- Mason-nvim-dap: Bridges Mason with nvim-dap
  {
    "jayp0521/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = {
          "php-debug-adapter",  -- For PHP/Laravel
          "js-debug-adapter",   -- For JavaScript/Vue
          "python",             -- For Python
        },
        automatic_installation = true,
        handlers = {
          function(config)
            -- All sources with no handler get passed here
            require('mason-nvim-dap').default_setup(config)
          end,
          php = function(config)
            config.configurations = {
              {
                type = "php",
                request = "launch",
                name = "Listen for Xdebug (Default)",
                port = 9003,
                pathMappings = {
                  ["/var/www/html"] = "${workspaceFolder}"
                }
              },
            }
            require('mason-nvim-dap').default_setup(config) -- don't forget this!
          end,
        },
      })
    end,
  },
}

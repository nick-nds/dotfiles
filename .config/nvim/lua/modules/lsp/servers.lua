-- LSP Server Configurations
-- Individual server settings and customizations

local M = {}

-- Mason ensure_installed servers (optimized list - only install what you actively use)
M.servers = {
  "phpactor",              -- PHP/Laravel (essential)
  "vue-language-server",   -- Vue 3 (Mason package name, maps to 'volar' in lspconfig)
  "typescript-language-server", -- TypeScript/JavaScript (essential) 
  -- "tailwindcss",        -- Tailwind (disabled - use manual control via tools/tailwind_control.lua)
  "jsonls",                -- JSON (correct Mason name)
  "html",                  -- HTML (correct Mason name)
  -- Optional servers (commented out to reduce resource usage)
  -- "eslint-lsp",         -- Enable only if you need ESLint
  -- "pyright",            -- Enable only if you work with Python
  -- "bash-language-server", -- Enable only if you write complex bash scripts
  -- "css-lsp",            -- Enable only if you write pure CSS (Tailwind covers most cases)
}

-- Server-specific configurations
M.server_configs = {
  -- PHP LSP (Laravel support) - Optimized for performance
  phpactor = {
    on_attach = function(client, bufnr)
      -- Limit capabilities to reduce resource usage
      client.server_capabilities.documentFormattingProvider = false -- Use Pint instead
      client.server_capabilities.documentRangeFormattingProvider = false
      client.server_capabilities.documentSymbolProvider = true -- Keep for navigation
      client.server_capabilities.workspaceSymbolProvider = false -- Disable expensive workspace symbols
      
      local lsp_config = require("modules.lsp.keymaps")
      lsp_config.on_attach(client, bufnr)
    end,
    root_dir = function(fname)
      local lspconfig = require("lspconfig")
      return lspconfig.util.find_git_ancestor(fname) or vim.fn.getcwd()
    end,
    init_options = {
      -- Performance optimizations
      ['language_server_phpstan.enabled'] = false, -- Disable heavy static analysis
      ['language_server_psalm.enabled'] = false,
      ['language_server_worse_reflection.enabled'] = false,
      ['indexer.enabled'] = true,
      ['indexer.exclude_patterns'] = {
        "/vendor/",
        "/var/",
        "/tmp/", 
        "/storage/",
        "/bootstrap/cache/",
        "/node_modules/",
        "/.git/",
        "/public/build/",
        "/public/hot",
      },
      ['indexer.poll_time'] = 5, -- Reduce polling frequency
      ['indexer.batch_size'] = 10, -- Smaller batch sizes
      ['symfony.enabled'] = false,
      ['language_server_completion.trim_leading_dollar'] = true,
      ['code_transform.import_globals'] = false, -- Disable expensive transforms
      ['composer.enable'] = true,
      ['language_server.diagnostic_providers'] = { 'php' }, -- Only basic PHP diagnostics
      ['completion.dedupe'] = true,
      ['completion.snippets'] = false, -- Reduce completion overhead
    },
    flags = {
      debounce_text_changes = 500, -- Increase debounce to reduce CPU
    },
  },

  -- Vue 3 LSP (Takeover mode) - Optimized
  volar = { -- lspconfig name is still 'volar' even though Mason package is 'vue-language-server'
    on_attach = function(client, bufnr)
      -- Disable expensive features for performance
      client.server_capabilities.documentFormattingProvider = false -- Use Prettier
      client.server_capabilities.documentRangeFormattingProvider = false
      client.server_capabilities.foldingRangeProvider = false -- Reduce overhead
      
      local lsp_config = require("modules.lsp.keymaps")
      lsp_config.on_attach(client, bufnr)
    end,
    filetypes = { "vue" }, -- Only Vue files, let tsserver handle TS/JS
    root_dir = function(fname)
      local lspconfig = require("lspconfig")
      return lspconfig.util.root_pattern("package.json", "vue.config.js", "vite.config.js")(fname)
    end,
    init_options = {
      vue = {
        hybridMode = false, -- use takeover mode
        server = {
          maxFileSize = 20971520, -- 20MB limit
          maxProjectFileSize = 104857600, -- 100MB project limit
        },
      },
      typescript = {
        tsdk = vim.fn.expand("$HOME/.local/share/nvim/mason/packages/typescript-language-server/node_modules/typescript/lib")
      }
    },
    settings = {
      vue = {
        server = {
          vitePress = {
            supportMdFile = false, -- Disable markdown support
          },
          petiteVue = {
            supportHtmlFile = false, -- Disable HTML support
          },
          vueCompilerOptions = {
            target = 3.3, -- Target Vue 3.3
          },
        },
      },
    },
    flags = {
      debounce_text_changes = 300,
    },
  },

  -- TypeScript LSP - Heavily optimized
  tsserver = {
    on_attach = function(client, bufnr)
      -- Disable expensive features
      client.server_capabilities.documentFormattingProvider = false -- Use Prettier
      client.server_capabilities.documentRangeFormattingProvider = false
      client.server_capabilities.documentSymbolProvider = true -- Keep for navigation
      client.server_capabilities.workspaceSymbolProvider = false -- Expensive operation
      client.server_capabilities.foldingRangeProvider = false -- Reduce overhead
      
      local lsp_config = require("modules.lsp.keymaps")
      lsp_config.on_attach(client, bufnr)
    end,
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    root_dir = function(fname)
      local lspconfig = require("lspconfig")
      return lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json")(fname)
    end,
    init_options = {
      maxTsServerMemory = 1024, -- Limit to 1GB
      preferences = {
        includeCompletionsForModuleExports = false, -- Reduce completion overhead
        includeCompletionsWithInsertText = false,
        allowIncompleteCompletions = false,
      },
    },
    settings = {
      typescript = {
        -- Disable expensive inlay hints to save resources
        inlayHints = {
          includeInlayParameterNameHints = "none", -- Disabled for performance
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = false,
          includeInlayVariableTypeHints = false,
          includeInlayPropertyDeclarationTypeHints = false,
          includeInlayFunctionLikeReturnTypeHints = false,
          includeInlayEnumMemberValueHints = false,
        },
        -- Optimize compilation
        preferences = {
          disableSuggestions = false,
          quotePreference = "auto",
          includeCompletionsForModuleExports = false,
          includeCompletionsForImportStatements = true,
          includeCompletionsWithSnippetText = false,
          includeAutomaticOptionalChainCompletions = false,
        },
        suggest = {
          completeFunctionCalls = false, -- Reduce completion complexity
        },
        -- Reduce diagnostic scope
        validate = {
          enable = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "none",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = false,
          includeInlayVariableTypeHints = false,
          includeInlayPropertyDeclarationTypeHints = false,
          includeInlayFunctionLikeReturnTypeHints = false,
          includeInlayEnumMemberValueHints = false,
        },
        suggest = {
          completeFunctionCalls = false,
        },
      }
    },
    flags = {
      debounce_text_changes = 500, -- Higher debounce
    },
  },

  -- ESLint LSP (Commented out - use null-ls eslint instead for better performance)
  -- eslint = {
  --   on_attach = function(client, bufnr)
  --     client.server_capabilities.documentFormattingProvider = false
  --     local lsp_config = require("modules.lsp.keymaps")
  --     lsp_config.on_attach(client, bufnr)
  --   end,
  --   settings = { 
  --     format = false, -- Disable formatting to prevent conflicts
  --     packageManager = "npm",
  --     codeActionOnSave = {
  --       enable = false, -- Reduce auto-actions
  --     },
  --   },
  --   root_dir = function(fname)
  --     local lspconfig = require("lspconfig")
  --     return lspconfig.util.root_pattern(".eslintrc", ".eslintrc.js", ".eslintrc.json")(fname)
  --   end,
  --   flags = {
  --     debounce_text_changes = 1000, -- High debounce for ESLint
  --   },
  -- },

  -- Python LSP (Commented out - enable only if needed)
  -- pyright = {
  --   on_attach = function(client, bufnr)
  --     client.server_capabilities.documentFormattingProvider = false -- Use Black instead
  --     local lsp_config = require("modules.lsp.keymaps")
  --     lsp_config.on_attach(client, bufnr)
  --   end,
  --   settings = {
  --     python = {
  --       analysis = {
  --         autoSearchPaths = false, -- Reduce indexing
  --         diagnosticMode = "openFilesOnly", -- Only check open files
  --         useLibraryCodeForTypes = false, -- Reduce memory usage
  --         typeCheckingMode = "off", -- Disable heavy type checking
  --         autoImportCompletions = false,
  --       }
  --     }
  --   },
  --   flags = {
  --     debounce_text_changes = 1000,
  --   },
  -- },

  -- Bash LSP (Commented out - enable only if needed)
  -- bashls = {
  --   on_attach = function(client, bufnr)
  --     client.server_capabilities.documentFormattingProvider = false
  --     local lsp_config = require("modules.lsp.keymaps")
  --     lsp_config.on_attach(client, bufnr)
  --   end,
  --   filetypes = { "sh", "bash" }, -- Reduced filetypes
  --   flags = {
  --     debounce_text_changes = 500,
  --   },
  -- },

  -- JSON LSP - Lightweight
  jsonls = {
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false -- Use Prettier
      local lsp_config = require("modules.lsp.keymaps")
      lsp_config.on_attach(client, bufnr)
    end,
    settings = {
      json = {
        -- Disable schemas to reduce memory usage
        schemas = {}, -- Comment out schemastore for performance
        validate = { enable = true },
        format = { enable = false }, -- Disable formatting
      }
    },
    flags = {
      debounce_text_changes = 300,
    },
  },

  -- HTML LSP - Lightweight
  html = {
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false -- Use Prettier
      local lsp_config = require("modules.lsp.keymaps")
      lsp_config.on_attach(client, bufnr)
    end,
    settings = {
      html = {
        format = {
          enable = false, -- Disable formatting
        },
      },
    },
    flags = {
      debounce_text_changes = 300,
    },
  },

  -- CSS LSP (Commented out - Tailwind covers most use cases)
  -- cssls = {
  --   on_attach = function(client, bufnr)
  --     client.server_capabilities.documentFormattingProvider = false -- Use Prettier
  --     local lsp_config = require("modules.lsp.keymaps")
  --     lsp_config.on_attach(client, bufnr)
  --   end,
  --   settings = {
  --     css = {
  --       validate = true,
  --       lint = {
  --         unknownAtRules = "ignore", -- Ignore Tailwind directives
  --       }
  --     }
  --   },
  --   flags = {
  --     debounce_text_changes = 300,
  --   },
  -- },

  -- Tailwind CSS LSP (Disabled - use manual control via tools/tailwind_control.lua)
  -- tailwindcss = {
  --   on_attach = function(client, bufnr)
  --     -- Disable document formatting (use prettier instead)
  --     client.server_capabilities.documentFormattingProvider = false
  --     client.server_capabilities.documentRangeFormattingProvider = false
  --     -- Disable expensive hover features for performance
  --     client.server_capabilities.hoverProvider = false
  --     -- Reduce completion capabilities
  --     client.server_capabilities.completionProvider.triggerCharacters = { "-", ":" }
  --     
  --     local lsp_config = require("modules.lsp.keymaps")
  --     lsp_config.on_attach(client, bufnr)
  --   end,
  --   root_dir = function(fname)
  --     local lspconfig = require("lspconfig")
  --     return lspconfig.util.root_pattern(
  --       "tailwind.config.js",
  --       "tailwind.config.ts", 
  --       "tailwind.config.cjs",
  --       "postcss.config.js",
  --       "package.json"
  --     )(fname)
  --   end,
  --   filetypes = {
  --     "html",
  --     "css",
  --     "scss",
  --     "javascript",
  --     "javascriptreact", 
  --     "typescript",
  --     "typescriptreact",
  --     "vue",
  --     "svelte",
  --     "php", -- For Laravel Blade
  --   },
  --   -- Add aggressive memory and CPU limits
  --   cmd_env = {
  --     NODE_OPTIONS = "--max-old-space-size=512 --max-semi-space-size=64", -- Limit to 512MB RAM
  --   },
  --   flags = {
  --     debounce_text_changes = 800, -- Higher debounce for better performance
  --     allow_incremental_sync = true,
  --     exit_timeout = 3000, -- Faster shutdown
  --   },
  --   init_options = {
  --     userLanguages = {
  --       php = "html", -- Treat PHP as HTML for Tailwind
  --     },
  --   },
  --   settings = {
  --     tailwindCSS = {
  --       -- Performance optimizations
  --       validate = false, -- Disable validation for performance
  --       lint = {
  --         cssConflict = "ignore", -- Reduce linting overhead
  --         invalidApply = "warning",
  --         invalidConfigPath = "ignore",
  --         invalidScreen = "ignore",
  --         invalidTailwindDirective = "warning",
  --         invalidVariant = "ignore",
  --         recommendedVariantOrder = "ignore" -- Disable expensive ordering checks
  --       },
  --       -- Aggressive file exclusions to reduce memory usage
  --       files = {
  --         exclude = {
  --           "**/.git/**",
  --           "**/node_modules/**",
  --           "**/dist/**",
  --           "**/build/**",
  --           "**/vendor/**",
  --           "**/.next/**",
  --           "**/.nuxt/**",
  --           "**/coverage/**",
  --           "**/.nyc_output/**",
  --           "**/cypress/**",
  --           "**/.cache/**",
  --           "**/public/**/*.js",
  --           "**/public/**/*.css",
  --           "**/storage/**",
  --           "**/bootstrap/cache/**",
  --           "**/.vscode/**",
  --           "**/.idea/**",
  --           "**/tests/**",
  --           "**/test/**",
  --         }
  --       },
  --       -- Minimal class regex for better performance
  --       experimental = {
  --         classRegex = {
  --           -- Only most essential patterns
  --           "class[:]?\\s*[\"'`]([^\"'`]*)[\"'`]",
  --           ":class\\s*=\\s*[\"'`]([^\"'`]*)[\"'`]",
  --           "className\\s*=\\s*[\"'`]([^\"'`]*)[\"'`]",
  --         }
  --       },
  --       -- Disable resource-heavy features
  --       hovers = false, -- Disable hover for better performance
  --       suggestions = true, -- Keep minimal completions
  --       -- Minimal completion attributes
  --       classAttributes = {
  --         "class",
  --         "className",
  --       },
  --       -- Disable all optional features for performance
  --       showPixelEquivalents = false,
  --       includeLanguages = {},
  --       rootFontSize = 16,
  --       -- Disable CSS-in-JS support (resource intensive)
  --       emmetCompletions = false,
  --       colorDecorators = false,
  --     }
  --   }
  -- },
}

-- Setup all servers with lspconfig
M.setup_servers = function()
  local lspconfig = require("lspconfig")
  local lsp_config = require("modules.lsp.keymaps")
  
  for server_name, config in pairs(M.server_configs) do
    -- Merge with default config
    local server_config = vim.tbl_deep_extend("force", {
      capabilities = lsp_config.get_capabilities(),
      on_attach = lsp_config.on_attach,
    }, config)
    
    -- Setup server with error handling
    local ok, err = pcall(function()
      lspconfig[server_name].setup(server_config)
    end)
    
    if not ok then
      vim.notify("Failed to setup LSP server: " .. server_name .. " - " .. tostring(err), vim.log.levels.WARN)
    end
  end
end

return M
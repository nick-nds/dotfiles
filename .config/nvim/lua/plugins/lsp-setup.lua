return {
  -- Mason: Install LSPs, linters, and formatters
  {
    "williamboman/mason.nvim",
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
        },
      })
    end,
  },

  -- Mason LSP Config: Bridges Mason with Neovim's LSP
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "intelephense", -- PHP LSP (Laravel support) 
          "volar", -- Vue 3 LSP
          "typescript-language-server", -- TypeScript/JavaScript LSP
          "eslint-lsp", -- JavaScript/TypeScript linting
          "pyright", -- Python LSP
          "bash-language-server", -- Bash LSP
          "json-lsp", -- JSON LSP
          "html-lsp", -- HTML LSP
          "css-lsp", -- CSS LSP
          "tailwindcss-language-server", -- Tailwind CSS LSP
        },
        automatic_installation = true,
      })
      
      -- Configure diagnostic display
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●', -- Could be '■', '▎', 'x', '●'
          source = "if_many", -- Only show source if multiple sources
          spacing = 4, -- Spacing between virtual text and code
          format = function(diagnostic)
            -- Truncate long messages to prevent exceeding screen width
            local message = diagnostic.message
            local max_length = 50 -- Maximum length for virtual text
            if #message > max_length then
              message = message:sub(1, max_length) .. "..."
            end
            
            -- Add severity level as prefix for better visibility
            local severity_levels = {
              [vim.diagnostic.severity.ERROR] = "Error: ",
              [vim.diagnostic.severity.WARN] = "Warning: ",
              [vim.diagnostic.severity.INFO] = "Info: ",
              [vim.diagnostic.severity.HINT] = "Hint: ",
            }
            local severity_icon = severity_levels[diagnostic.severity] or ""
            return severity_icon .. message
          end,
        },
        signs = true,             -- Show signs in the sign column
        underline = true,         -- Underline text with diagnostic
        update_in_insert = false, -- Update diagnostics in insert mode
        severity_sort = true,     -- Sort diagnostics by severity
        float = {
          border = "rounded",     -- Add border to floating windows
          source = "always",      -- Always show source of diagnostic
          header = "",            -- No header in floating windows
          prefix = "",            -- No prefix in floating windows
          max_width = 80,         -- Maximum width for floating window
          max_height = 20,        -- Maximum height for floating window
        },
      })
      
      -- Set custom diagnostic signs
      local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
      
      -- Add a function to toggle virtual text diagnostics
      local virtual_text_enabled = true
      vim.api.nvim_create_user_command("ToggleDiagnosticVirtualText", function()
        virtual_text_enabled = not virtual_text_enabled
        if virtual_text_enabled then
          vim.diagnostic.config({ 
            virtual_text = {
              prefix = '●',
              source = "if_many",
              spacing = 4,
              format = function(diagnostic)
                local message = diagnostic.message
                local max_length = 50
                if #message > max_length then
                  message = message:sub(1, max_length) .. "..."
                end
                
                local severity_levels = {
                  [vim.diagnostic.severity.ERROR] = "Error: ",
                  [vim.diagnostic.severity.WARN] = "Warning: ",
                  [vim.diagnostic.severity.INFO] = "Info: ",
                  [vim.diagnostic.severity.HINT] = "Hint: ",
                }
                local severity_icon = severity_levels[diagnostic.severity] or ""
                return severity_icon .. message
              end,
            }
          })
          print("Diagnostic virtual text enabled")
        else
          vim.diagnostic.config({ virtual_text = false })
          print("Diagnostic virtual text disabled")
        end
      end, {})
      
      -- Add keybinding for toggling diagnostic virtual text (using <leader>dv to avoid conflict with DAP)
      vim.keymap.set("n", "<leader>dv", ":ToggleDiagnosticVirtualText<CR>", { noremap = true, silent = true, desc = "Toggle Diagnostic Text" })

      -- Global on_attach function to be used by all LSP servers
      local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "<leader>lf", function()
          vim.lsp.buf.format({ async = true })
        end, { noremap = true, silent = true, buffer = bufnr, desc = "Format Code" })

        vim.keymap.set("n", "<leader>ca", function()
          vim.lsp.buf.code_action()
        end, { noremap = true, silent = true, buffer = bufnr, desc = "Code Action" })

        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover Documentation" })
        vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
        vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Find References" })
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename Symbol" })
        vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to Implementation" })
        vim.keymap.set("n", "<leader>gl", vim.diagnostic.open_float, { buffer = bufnr, desc = "Line Diagnostics" })
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Previous Diagnostic" })
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next Diagnostic" })
        vim.keymap.set("n", "<leader>ld", function() 
          vim.diagnostic.setloclist() -- Add diagnostics to the location list
        end, { buffer = bufnr, desc = "List Diagnostics" })
      end

      -- Configure LSP clients
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- PHP LSP (Laravel support)
      lspconfig.intelephense.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          intelephense = {
            format = { enable = true },
            stubs = {
              "apache", "bcmath", "bz2", "calendar", "com_dotnet", "Core", "ctype",
              "curl", "date", "dba", "dom", "enchant", "exif", "fileinfo", "filter",
              "fpm", "ftp", "gd", "hash", "iconv", "imap", "intl", "json", "ldap",
              "libxml", "mbstring", "meta", "mysqli", "oci8", "odbc", "openssl", "pcntl",
              "pcre", "PDO", "pdo_ibm", "pdo_mysql", "pdo_pgsql", "pdo_sqlite", "pgsql",
              "Phar", "posix", "pspell", "readline", "Reflection", "session", "shmop",
              "SimpleXML", "snmp", "soap", "sockets", "sodium", "SPL", "sqlite3", "standard",
              "superglobals", "sysvmsg", "sysvsem", "sysvshm", "tidy", "tokenizer", "xml",
              "xmlreader", "xmlrpc", "xmlwriter", "xsl", "Zend OPcache", "zip", "zlib",
              "wordpress", "phpunit", "laravel", "blade"
            },
            environment = {
              includePaths = { "/vendor" }
            },
            codeAction = { enable = true },
            completion = {
              insertUseDeclaration = true,
              fullyQualifyGlobalConstantsAndFunctions = false,
              preferClassConstantReference = true,
            },
            files = { maxSize = 5000000 },
            telemetry = { enable = false },
          },
        },
      })

      -- Vue 3 LSP (Takeover mode)
      lspconfig.volar.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "vue", "typescript", "javascript" },
        init_options = {
          vue = {
            hybridMode = false, -- use takeover mode for TypeScript integration
          },
          typescript = {
            tsdk = vim.fn.expand("$HOME/.local/share/nvim/mason/packages/typescript-language-server/node_modules/typescript/lib")
          }
        }
      })

      -- TypeScript LSP
      lspconfig.tsserver.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          -- Disable tsserver formatting as we'll use prettier/eslint
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          on_attach(client, bufnr)
        end,
        root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            }
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            }
          }
        }
      })

      -- ESLint LSP
      lspconfig.eslint.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = { 
          format = true,
          packageManager = "npm",
        },
        root_dir = lspconfig.util.root_pattern(".eslintrc", ".eslintrc.js", ".eslintrc.json")
      })

      -- Python LSP
      lspconfig.pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "basic",
            }
          }
        }
      })

      -- Bash LSP
      lspconfig.bashls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "sh", "bash", "zsh" }
      })

      -- JSON LSP
      lspconfig.jsonls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          }
        }
      })

      -- HTML LSP
      lspconfig.html.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- CSS LSP
      lspconfig.cssls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- Tailwind CSS LSP
      lspconfig.tailwindcss.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                "class[:]\\s*\"([^\"]*)", -- class: "..."
                "class[:]\\s*'([^']*)", -- class: '...'
                "class[:]\\s*`([^`]*)", -- class: `...`
                "class[:]\\s*(.*)" -- class: ...
              }
            }
          }
        }
      })
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

      -- Verify available builtins to prevent errors
      local has_formatter = function(formatter)
        return formatter and null_ls.builtins.formatting[formatter] ~= nil
      end
      
      local has_diagnostic = function(diagnostic)
        return diagnostic and null_ls.builtins.diagnostics[diagnostic] ~= nil
      end
      
      local has_action = function(action)
        return action and null_ls.builtins.code_actions[action] ~= nil
      end

      -- Register Laravel Pint as a custom formatter with enhanced settings
      local pint = {
        name = "laravel_pint",
        method = null_ls.methods.FORMATTING,
        filetypes = { "php" },
        generator = null_ls.generator({
          command = "pint",
          args = function(params)
            -- Include important args for Pint
            return {
              "--no-interaction",
              "--quiet",
              params.temp_path -- Output to a temp file
            }
          end,
          to_temp_file = true,
          from_temp_file = true,
          format = "raw",
          check_exit_code = function(code)
            return code <= 1 -- 0 = success, 1 = fixed, >1 = error
          end,
          on_output = function(params, done)
            return done(params.output)
          end,
        }),
      }

      null_ls.register(pint)

      -- Collect available sources
      local sources = {}

      -- Formatters
      if has_formatter("prettier") then
        table.insert(sources, null_ls.builtins.formatting.prettier.with({
          prefer_local = "node_modules/.bin",
          filetypes = {
            "javascript", 
            "javascriptreact", 
            "typescript", 
            "typescriptreact", 
            "vue", 
            "css", 
            "scss", 
            "less", 
            "html", 
            "json", 
            "yaml", 
            "markdown", 
            "graphql"
          },
        }))
      end
      
      if has_formatter("phpcsfixer") then
        table.insert(sources, null_ls.builtins.formatting.phpcsfixer.with({
          prefer_local = "vendor/bin",
        }))
      end
      
      -- Add custom pint formatter
      table.insert(sources, pint)
      
      if has_formatter("black") then
        table.insert(sources, null_ls.builtins.formatting.black.with({
          extra_args = {"--fast"},
        }))
      end
      
      if has_formatter("isort") then
        table.insert(sources, null_ls.builtins.formatting.isort.with({
          args = {"--profile", "black", "-"},
        }))
      end
      
      if has_formatter("shfmt") then  
        table.insert(sources, null_ls.builtins.formatting.shfmt)
      end

      -- Linters
      if has_diagnostic("eslint") then
        table.insert(sources, null_ls.builtins.diagnostics.eslint.with({
          prefer_local = "node_modules/.bin",
        }))
      end
      
      -- PHPCS disabled - using Pint only for Laravel projects
      
      if has_diagnostic("phpstan") then
        table.insert(sources, null_ls.builtins.diagnostics.phpstan.with({
          prefer_local = "vendor/bin",
        }))
      end
      
      if has_diagnostic("flake8") then
        table.insert(sources, null_ls.builtins.diagnostics.flake8)
      end
      
      if has_diagnostic("shellcheck") then
        table.insert(sources, null_ls.builtins.diagnostics.shellcheck)
      end

      -- Code Actions
      if has_action("eslint") then
        table.insert(sources, null_ls.builtins.code_actions.eslint.with({
          prefer_local = "node_modules/.bin",
        }))
      end
      
      if has_action("shellcheck") then
        table.insert(sources, null_ls.builtins.code_actions.shellcheck)
      end

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
      require("mason-null-ls").setup({
        ensure_installed = { 
          "prettier", 
          "php-cs-fixer", -- Keep php-cs-fixer as Pint uses it internally
          "eslint", 
          "phpstan",
          "black",
          "isort", 
          "flake8",
          "shellcheck",
          "shfmt"
        },
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
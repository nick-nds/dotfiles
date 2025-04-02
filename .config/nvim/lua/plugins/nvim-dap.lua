return {
    'mfussenegger/nvim-dap',
    lazy = false,
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        "nvim-telescope/telescope-dap.nvim",
        "nvim-neotest/nvim-nio",
        "jayp0521/mason-nvim-dap.nvim",
    },
    config = function()
        local dap, dapui = require("dap"), require("dapui")
        require("telescope").load_extension("dap")
        require("nvim-dap-virtual-text").setup()

        -- Configure DAP UI
        dapui.setup({
            icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
            mappings = {
                -- Use a table to apply multiple mappings
                expand = { "<CR>", "<2-LeftMouse>" },
                open = "o",
                remove = "d",
                edit = "e",
                repl = "r",
                toggle = "t",
            },
            -- Expand lines larger than the window
            -- Requires >= 0.7
            expand_lines = vim.fn.has("nvim-0.7") == 1,
            layouts = {
                {
                    elements = {
                        -- Elements can be strings or table with id and size keys.
                        { id = "scopes", size = 0.25 },
                        "breakpoints",
                        "stacks",
                        "watches",
                    },
                    size = 40, -- 40 columns
                    position = "left",
                },
                {
                    elements = {
                        "repl",
                        "console",
                    },
                    size = 0.25, -- 25% of total lines
                    position = "bottom",
                },
            },
            controls = {
                -- Requires Neovim nightly (or 0.8 when released)
                enabled = true,
                -- Display controls in this element
                element = "repl",
                icons = {
                    pause = "",
                    play = "",
                    step_into = "",
                    step_over = "",
                    step_out = "",
                    step_back = "",
                    run_last = "",
                    terminate = "",
                },
            },
            floating = {
                max_height = nil, -- These can be integers or a float between 0 and 1.
                max_width = nil, -- Floats will be treated as percentage of your screen.
                border = "single", -- Border style. Can be "single", "double" or "rounded"
                mappings = {
                    close = { "q", "<Esc>" },
                },
            },
        })

        -- Auto open/close DAP UI
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end

        -- PHP DAP configurations (Laravel projects)
        -- These will be enhanced by mason-nvim-dap, but we add custom project configurations
        local cwd = vim.fn.getcwd()
        local branch = cwd:match("([^/]+)$")
        
        local function server_path(project)
            return '/app/' .. project .. '/' .. branch
        end

        dap.configurations.php = dap.configurations.php or {}
        table.insert(dap.configurations.php, {
            type = 'php',
            request = 'launch',
            name = 'Listen for Xdebug farmd',
            port = 9003,
            pathMappings = {
                ['/app/'] = cwd .. '/'
            }
        })
        
        table.insert(dap.configurations.php, {
            type = 'php',
            request = 'launch',
            name = 'Listen for Xdebug backend',
            port = 9003,
            pathMappings = {
                [server_path('api.farmd.test')] = cwd .. '/'
            }
        })
        
        table.insert(dap.configurations.php, {
            type = 'php',
            request = 'launch',
            name = 'Listen for Xdebug bistrokeep',
            port = 9003,
            pathMappings = {
                [server_path('bistrokeep.test')] = cwd .. '/'
            }
        })
        
        table.insert(dap.configurations.php, {
            type = 'php',
            request = 'launch',
            name = 'Listen for Xdebug momskitchen',
            port = 9003,
            pathMappings = {
                [server_path('api.momskitchen.test')] = cwd .. '/'
            }
        })

        -- JavaScript/TypeScript/Vue DAP configurations
        dap.configurations.javascript = {
            {
                type = "pwa-node",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                cwd = "${workspaceFolder}",
            },
            {
                type = "pwa-node",
                request = "attach",
                name = "Attach",
                processId = require('dap.utils').pick_process,
                cwd = "${workspaceFolder}",
            },
            {
                type = "pwa-chrome",
                request = "launch",
                name = "Launch Chrome",
                url = "http://localhost:3000",
                webRoot = "${workspaceFolder}",
                userDataDir = "${workspaceFolder}/.vscode/chrome-debug-profile",
            }
        }
        
        dap.configurations.typescript = dap.configurations.javascript
        dap.configurations.vue = dap.configurations.javascript

        -- Python DAP configurations
        dap.configurations.python = {
            {
                type = "python",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                pythonPath = function()
                    -- Try to detect python path from active virtual environment
                    local venv_path = os.getenv("VIRTUAL_ENV")
                    if venv_path then
                        return venv_path .. "/bin/python"
                    end
                    -- If there is no active venv, use system python
                    return "python3"
                end,
            },
            {
                type = "python",
                request = "launch",
                name = "Django",
                program = "${workspaceFolder}/manage.py",
                args = {"runserver", "--noreload"},
                pythonPath = function()
                    local venv_path = os.getenv("VIRTUAL_ENV")
                    if venv_path then
                        return venv_path .. "/bin/python"
                    end
                    return "python3"
                end,
            },
        }
    end,
    keys = {
        { '<F5>', "<cmd>lua require('dap').continue()<cr>", desc = "Continue/Start Debugging" },
        { '<F10>', "<cmd>lua require('dap').step_over()<cr>", desc = "Step Over" },
        { '<F11>', "<cmd>lua require('dap').step_into()<cr>", desc = "Step Into" },
        { '<F12>', "<cmd>lua require('dap').step_out()<cr>", desc = "Step Out" },
        { '<Leader>db', "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Toggle Breakpoint" },
        { '<Leader>dB', "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", desc = "Conditional Breakpoint" },
        { '<Leader>dl', "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>", desc = "Logpoint" },
        { '<Leader>dr', "<cmd>lua require('dap').repl.open()<cr>", desc = "Open REPL" },
        { '<Leader>dl', "<cmd>lua require('dap').run_last()<cr>", desc = "Run Last Debug Configuration" },
        { '<Leader>dh', function() require('dap.ui.widgets').hover() end, mode = { "n", "v" }, desc = "Variables Hover" },
        { '<Leader>dp', function() require('dap.ui.widgets').preview() end, mode = { "n", "v" }, desc = "Preview" },
        { '<Leader>df', function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.frames)
        end, desc = "Stack Frames" },
        { '<Leader>ds', function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.scopes)
        end, desc = "Scopes" },
        { '<Leader>dt', "<cmd>lua require('dapui').toggle()<cr>", desc = "Toggle DAP UI" },
    }
}

return {
    'mfussenegger/nvim-dap',
    lazy=false,
    dependencies = {
        {
            "rcarriga/nvim-dap-ui",
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
            'theHamsta/nvim-dap-virtual-text',
            'nvim-telescope/telescope-dap.nvim',
        }
    },
    config = function()
        local dap, dapui = require("dap"), require("dapui")
        require("telescope").load_extension("dap")

        dapui.setup()

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        dap.adapters.php = {
            type = 'executable',
            command = '/home/nick/.nvm/versions/node/v16.14.2/bin/node',
            args = { '/home/nick/.debuggers/vscode-php-debug/out/phpDebug.js' }
        }

        -- get current working directory
        local cwd = vim.fn.getcwd()
        -- get last folder name of current working directory
        local server_path = function(project)
            local branch = cwd:match("([^/]+)$")
            return '/app/' .. project .. '/' .. branch
        end
        local branch = cwd:match("([^/]+)$")

        dap.configurations.php = {
            {
                type = 'php',
                request = 'launch',
                name = 'Listen for Xdebug backend',
                port = 9003,
                pathMappings = {
                    [server_path('apnithali.test')] = cwd .. '/'
                    -- ['/var/www/html/' .. branch] = cwd .. '/'
                }
            },
            -- {
            --     type = 'php',
            --     request = 'launch',
            --     name = 'Listen for Xdebug apnithali',
            --     port = 9003,
            --     pathMappings = {
            --         [server_path('apnithali.test')] = cwd .. '/'
            --     }
            -- }
        }
    end,
    keys = {
        { '<F5>', "<cmd>lua require('dap').continue()<cr>" },
        { '<F10>', "<cmd>lua require('dap').step_over()<cr>" },
        { '<F11>', "<cmd>lua require('dap').step_into()<cr>" },
        { '<F12>', "<cmd>lua require('dap').step_out()<cr>" },
        { '<Leader>db', "<cmd>lua require('dap').toggle_breakpoint()<cr>" },
        { '<Leader>dB', "<cmd>lua require('dap').set_breakpoint()<cr>" },
        { '<Leader>dl', "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>" },
        { '<Leader>dr', "<cmd>lua require('dap').repl.open()<cr>" },
        { '<Leader>dl', "<cmd>lua require('dap').run_last()<cr>" },

        { '<Leader>dh', function() require('dap.ui.widgets').hover() end, mode = { "n", "v" } },

        { '<Leader>dp', function() require('dap.ui.widgets').preview() end, mode = { "n", "v" } },

        { '<Leader>df', function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.frames)
        end },

        { '<Leader>ds', function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.scopes)
        end },

        { '<Leader>dr', function()
            require('dapui').float_element('repl', {
                enter = true,
                position = 'center'
            })
        end },

        { '<Leader>dt', "<cmd>lua require('dapui').toggle()<cr>" },
    }
}

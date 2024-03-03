local M = {}
M.setup = function()
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
        args = { '/home/nick/.config/nvim/vscode-php-debug/out/phpDebug.js' }
    }

    dap.configurations.php = {
        {
            type = 'php',
            request = 'launch',
            name = 'Listen for Xdebug',
            port = 9003,
            pathMappings = {
                ['/var/www/html/html'] = vim.fn.getcwd() .. '/',
            }
        }
    }

    local opts = { noremap = true, silent = true }
    -- local kmap = vim.key.set
    local kmap = vim.api.nvim_set_keymap
    kmap('n', '<F5>', "<cmd>lua require('dap').continue()<cr>", opts)
    kmap('n', '<F10>', "<cmd>lua require('dap').step_over()<cr>", opts)
    kmap('n', '<F11>', "<cmd>lua require('dap').step_into()<cr>", opts)
    kmap('n', '<F12>', "<cmd>lua require('dap').step_out()<cr>", opts)
    kmap('n', '<Leader>db', "<cmd>lua require('dap').toggle_breakpoint()<cr>", opts)
    kmap('n', '<Leader>dB', "<cmd>lua require('dap').set_breakpoint()<cr>", opts)
    kmap('n', '<Leader>dl', "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>", opts)
    kmap('n', '<Leader>dr', "<cmd>lua require('dap').repl.open()<cr>", opts)
    kmap('n', '<Leader>dl', "<cmd>lua require('dap').run_last()<cr>", opts)
        vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
      require('dap.ui.widgets').hover()
    end)
    vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
      require('dap.ui.widgets').preview()
    end)
    vim.keymap.set('n', '<Leader>df', function()
      local widgets = require('dap.ui.widgets')
      widgets.centered_float(widgets.frames)
    end)
    vim.keymap.set('n', '<Leader>ds', function()
      local widgets = require('dap.ui.widgets')
      widgets.centered_float(widgets.scopes)
    end)

end

return M

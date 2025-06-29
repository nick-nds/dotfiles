local opts = { noremap = true, silent = true }

-- Pane Navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

-- Clipboard operations
vim.keymap.set({'n', 'v'}, 'cp', '"+y', opts) -- Yank to system clipboard

--simple remaps
vim.keymap.set('n', '<leader>e', '<cmd>q<cr>',  opts) --quit vim
vim.keymap.set('n', '<leader>q', '<cmd>qa<cr>',  opts) --quit vim
vim.keymap.set('n', '<leader>T', '<cmd>tabclose<cr>',  opts) --close active tab
vim.keymap.set('n', '<leader>t', '<cmd>tabs<cr>',  opts) --view tabs
vim.keymap.set('n', '<C-t>', '<cmd>tabnew<cr>',  opts) --new tab
vim.keymap.set('n', '<C-left>', '<cmd>tabmove -1<cr>',  opts) --move tab left
vim.keymap.set('n', '<C-right>', '<cmd>tabmove +1<cr>',  opts) --move tab right
vim.keymap.set('n', '<leader>b', '<C-^>',  opts)

-- Snippet-specific keybindings
vim.keymap.set('n', '<leader>ss', function()
    -- Use pcall to handle errors gracefully
    local status, error = pcall(function()
        local snippets = require("utils.snippets")
        snippets.reload()
    end)
    
    if not status then
        vim.notify("Error reloading snippets: " .. tostring(error), vim.log.levels.ERROR)
    end
end, { noremap = true, silent = true, desc = "Reload snippets" })

-- Laravel Pint tools loaded when needed

-- Load Tailwind control tools
local tailwind_control = require("modules.lsp.tailwind")
tailwind_control.setup()

-- Load LSP control and monitoring
local lsp_control = require("modules.lsp.control")
lsp_control.setup()

-- Global LSP keybindings (fallback if buffer-local ones don't work)
vim.keymap.set('n', '<leader>gd', function()
  local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
  local clients = get_clients({ bufnr = 0 })
  if #clients == 0 then
    vim.notify("No LSP clients attached to current buffer", vim.log.levels.WARN)
    return
  end
  
  vim.notify(string.format("Global go to definition (clients: %s)", 
    table.concat(vim.tbl_map(function(c) return c.name end, clients), ", ")), 
    vim.log.levels.INFO)
  vim.lsp.buf.definition()
end, { noremap = true, silent = true, desc = "Go to Definition (Global)" })

-- Basic vim settings
vim.opt.shortmess:append "c"
vim.opt.whichwrap:append "<,>,[,],h,l"

-- Make compatible with st, truecolors
vim["&t_8f"] = "\\<Esc>[38;2;%lu;%lu;%lum"
vim["&t_8b"] = "\\<Esc>[48;2;%lu;%lu;%lum"
vim.opt.termguicolors = true

-- Macros
vim.cmd [[set formatoptions-=cro]]

-- Config commands
vim.api.nvim_create_user_command('KeybindingsEdit', function()
    vim.cmd('edit ' .. vim.fn.stdpath('config') .. '/KEYBINDINGS.md')
end, { desc = 'Open Neovim keybindings reference' })

-- Config keybindings
vim.keymap.set('n', '<leader>hc', '<cmd>KeybindingsEdit<cr>', { desc = 'Open Keybindings Reference' })

-- Load Laravel testing utilities (for system PHP)
require("utils.laravel-testing").setup_keymaps()
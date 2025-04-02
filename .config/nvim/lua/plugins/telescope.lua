--telescope bitch
return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = {
        { 'nvim-lua/plenary.nvim' },
        { 'BurntSushi/ripgrep' },
    },
    config = function()
        require("telescope").setup({
            defaults = {
                layout_config = {
                  vertical = { width = 0.5 }
                },
                file_ignore_patterns = { "node_modules", "public/*" }
            },
            pickers = {
              find_files = {
                theme = "dropdown"
              }
            },
        })
        -- disable folding in telescope's result window
        vim.api.nvim_exec([[
            autocmd! FileType TelescopeResults setlocal nofoldenable
        ]], false)
        local dropdown = require('telescope.themes').get_dropdown()
    end,
    keys = {
        { '<leader>g', function() require("telescope.builtin").grep_string(
          require('telescope.themes').get_dropdown()
        ) end },
        { '<leader>ff', function() require("telescope.builtin").find_files(
          require('telescope.themes').get_dropdown()
        ) end },
        { '<leader>gg', function() require("telescope.builtin").git_files(
          require('telescope.themes').get_dropdown()
        ) end },
        { '<leader>GG', function() require("telescope.builtin").live_grep(
          require('telescope.themes').get_dropdown()
        ) end },
        { '<leader>rr', function() require("telescope.builtin").registers(
          require('telescope.themes').get_dropdown()
        ) end },
        { '<leader>fb', function() require("telescope.builtin").buffers(
          require('telescope.themes').get_dropdown()
        ) end },
        { '<leader>ft', function() require("telescope.builtin").tags(
          require('telescope.themes').get_dropdown()
        ) end },
        { '<leader>qf', function() require("telescope.builtin").quickfixhistory(
          require('telescope.themes').get_dropdown()
        ) end },
        { '<leader>qff', function() require("telescope.builtin").quickfix(
          require('telescope.themes').get_dropdown()
        ) end },
    }
}

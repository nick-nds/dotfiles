--telescope bitch
return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    lazy = true,
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
        -- Store last search for replay functionality
        { '<leader>fg', function() 
            local opts = require('telescope.themes').get_dropdown()
            require("telescope.builtin").grep_string(opts)
            -- Store search info globally
            vim.g.telescope_last_search = {
                type = "grep_string",
                opts = opts,
                query = vim.fn.expand("<cword>")
            }
        end },
        { '<leader>ff', function() require("telescope.builtin").find_files(
          require('telescope.themes').get_dropdown()
        ) end },
        { '<leader>gg', function() require("telescope.builtin").git_files(
          require('telescope.themes').get_dropdown()
        ) end },
        { '<leader>GG', function() 
            local opts = require('telescope.themes').get_dropdown()
            require("telescope.builtin").live_grep(opts)
            -- Store search info globally
            vim.g.telescope_last_search = {
                type = "live_grep",
                opts = opts,
                query = ""
            }
        end },
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
        
        -- Enhanced search functionality
        { '<leader>fw', function() 
            local word = vim.fn.expand("<cword>")
            local opts = require('telescope.themes').get_dropdown()
            opts.search = word
            require("telescope.builtin").grep_string(opts)
            -- Store for replay
            vim.g.telescope_last_search = {
                type = "grep_string",
                opts = opts,
                query = word
            }
        end, desc = "Search word under cursor" },
        
        { '<leader>fW', function() 
            local word = vim.fn.expand("<cWORD>")
            local opts = require('telescope.themes').get_dropdown()
            opts.search = word
            require("telescope.builtin").grep_string(opts)
            -- Store for replay
            vim.g.telescope_last_search = {
                type = "grep_string", 
                opts = opts,
                query = word
            }
        end, desc = "Search WORD under cursor" },
        
        { '<leader>fl', function()
            local last_search = vim.g.telescope_last_search
            if last_search and last_search.type then
                if last_search.type == "grep_string" then
                    require("telescope.builtin").grep_string(last_search.opts)
                elseif last_search.type == "live_grep" then
                    local opts = vim.tbl_deep_extend("force", last_search.opts, {
                        default_text = last_search.query
                    })
                    require("telescope.builtin").live_grep(opts)
                elseif last_search.type == "find_files" then
                    local opts = vim.tbl_deep_extend("force", last_search.opts, {
                        default_text = last_search.query
                    })
                    require("telescope.builtin").find_files(opts)
                end
            else
                vim.notify("No previous search to replay", vim.log.levels.WARN)
            end
        end, desc = "Replay last search" },
        
        { '<leader>fs', function()
            local opts = require('telescope.themes').get_dropdown()
            opts.search = vim.fn.input("Search string: ")
            if opts.search and opts.search ~= "" then
                require("telescope.builtin").grep_string(opts)
                vim.g.telescope_last_search = {
                    type = "grep_string",
                    opts = opts,
                    query = opts.search
                }
            end
        end, desc = "Search string (prompt)" },
        
        { '<leader>fr', function()
            require("telescope.builtin").resume()
        end, desc = "Resume last telescope search" },
        
        { '<leader>fh', function()
            local opts = require('telescope.themes').get_dropdown()
            require("telescope.builtin").search_history(opts)
        end, desc = "Search history" },
        
        { '<leader>fd', function()
            local opts = require('telescope.themes').get_dropdown()
            require("telescope.builtin").diagnostics(opts)
        end, desc = "Diagnostics" },
        
        { '<leader>fk', function()
            local opts = require('telescope.themes').get_dropdown()
            require("telescope.builtin").keymaps(opts)
        end, desc = "Keymaps" },
        
        { '<leader>fo', function()
            local opts = require('telescope.themes').get_dropdown()
            require("telescope.builtin").oldfiles(opts)
        end, desc = "Recent files" },
        
        { '<leader>fm', function()
            local opts = require('telescope.themes').get_dropdown()
            require("telescope.builtin").marks(opts)
        end, desc = "Marks" },
        
        { '<leader>fj', function()
            local opts = require('telescope.themes').get_dropdown()
            require("telescope.builtin").jumplist(opts)
        end, desc = "Jump list" },
        
        { '<leader>fv', function()
            local opts = require('telescope.themes').get_dropdown()
            require("telescope.builtin").vim_options(opts)
        end, desc = "Vim options" },
        
        { '<leader>fz', function()
            local opts = require('telescope.themes').get_dropdown()
            require("telescope.builtin").current_buffer_fuzzy_find(opts)
        end, desc = "Fuzzy find in current buffer" },
        
        { '<leader>fc', function()
            local opts = require('telescope.themes').get_dropdown()
            require("telescope.builtin").command_history(opts)
        end, desc = "Command history" },
    }
}

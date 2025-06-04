return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        { 'neovim/nvim-lspconfig' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-cmdline' },
        { 'zbirenbaum/copilot-cmp' },
        { 'onsails/lspkind.nvim' },
        { 'rcarriga/cmp-dap' },
        { 'gbprod/yanky.nvim' },
        { 'chrisgrieser/cmp_yanky' },
        { 'delphinus/cmp-ctags' },
        { 'L3MON4D3/LuaSnip' },            -- Snippet engine
        { 'saadparwaiz1/cmp_luasnip' },    -- Snippet source for cmp
        { 'rafamadriz/friendly-snippets' } -- Snippet collection
    },
    config = function()
        local cmp = require("cmp")
        local lspkind = require('lspkind')
        local luasnip = require("luasnip")

        -- Load friendly-snippets
        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            formatting = {
                format = lspkind.cmp_format({
                    mode = 'symbol_text',
                    symbol_map = {
                        Copilot = "",
                        Text = "󰉿",
                        Method = "󰆧",
                        Function = "󰊕",
                        Constructor = "",
                        Field = "󰜢",
                        Variable = "󰀫",
                        Class = "󰠱",
                        Interface = "",
                        Module = "",
                        Property = "󰜢",
                        Unit = "󰑭",
                        Value = "󰎠",
                        Enum = "",
                        Keyword = "󰌋",
                        Snippet = "",
                        Color = "󰏘",
                        File = "󰈙",
                        Reference = "󰈇",
                        Folder = "󰉋",
                        EnumMember = "",
                        Constant = "󰏿",
                        Struct = "󰙅",
                        Event = "",
                        Operator = "󰆕",
                    },
                    maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
                    ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
                    show_labelDetails = true, -- show labelDetails in menu
                    menu = {
                        buffer = "[Buffer]",
                        nvim_lsp = "[LSP]",
                        copilot = "[Copilot]",
                        luasnip = "[Snippet]",
                        nvim_lua = "[Lua]",
                        path = "[Path]",
                        ctags = "[Tags]",
                        cmp_yanky = "[Yanky]",
                    },
                })
            },
            sorting = {
                priority_weight = 2,
                comparators = (function()
                    local comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,
                        cmp.config.compare.recently_used,
                        cmp.config.compare.locality,
                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    }
                    
                    -- Only add copilot comparator if available
                    local ok, copilot_comparator = pcall(require, "copilot_cmp.comparators")
                    if ok then
                        table.insert(comparators, 1, copilot_comparator.prioritize)
                    end
                    
                    return comparators
                end)(),
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                -- Tab navigation for snippets and completion
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp', priority = 1000 },
                { name = 'copilot', priority = 900 },
                { name = 'luasnip', priority = 800 },
                { name = 'buffer', priority = 500 },
                { name = 'path', priority = 250 },
                { name = 'cmp_yanky', priority = 200 },
                { name = 'ctags', priority = 100 },
            }),
            experimental = {
                ghost_text = true,
            },
        })

        -- Completions for command mode (/ and ?)
        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        -- Completions for command line (:)
        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' }
            }, {
                { name = 'cmdline' }
            }),
            matching = { disallow_symbol_nonprefix_matching = false }
        })

        -- Completion for DAP
        cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
            sources = {
                { name = "dap" },
            },
        })

        -- Make sure nvim-cmp doesn't interfere with completion in the prompt buffer
        cmp.setup({
            enabled = function()
                return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
                    or require("cmp_dap").is_dap_buffer()
            end
        })
    end,
}

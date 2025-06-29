return {
    "hrsh7th/nvim-cmp",
    lazy = false, -- Essential for completion
    dependencies = {
        { 'neovim/nvim-lspconfig' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-cmdline' },
        { 'onsails/lspkind.nvim' },
        { 'rcarriga/cmp-dap' },
        { 'delphinus/cmp-ctags' },
        { 'L3MON4D3/LuaSnip' },            -- Snippet engine
        { 'saadparwaiz1/cmp_luasnip' },    -- Snippet source for cmp
        { 'rafamadriz/friendly-snippets' } -- Snippet collection
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local completion_config = require("modules.completion.config")

        -- Load friendly-snippets
        require("luasnip.loaders.from_vscode").lazy_load()
        
        -- Load custom snippets
        require("utils.snippets")

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
            formatting = completion_config.formatting,
            sorting = {
                priority_weight = completion_config.sorting.priority_weight,
                comparators = completion_config.sorting.comparators(),
            },
            mapping = completion_config.get_mappings(cmp, luasnip),
            sources = cmp.config.sources(completion_config.sources),
            experimental = {
                ghost_text = false, -- Disable for performance
            },
        })

        -- Setup command line completion
        completion_config.setup_cmdline(cmp)
        
        -- Setup DAP completion
        completion_config.setup_dap(cmp)
        
        -- Setup conditional completion
        completion_config.setup_conditional(cmp)
    end,
}

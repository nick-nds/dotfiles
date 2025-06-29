-- Completion Configuration Module
-- CMP sources, formatting, and behavior

local M = {}

-- CMP source priorities and configuration
M.sources = {
  { name = 'nvim_lsp', priority = 1000, group_index = 1 },
  { name = 'luasnip', priority = 900, group_index = 1 },
  { name = 'buffer', priority = 500, group_index = 2, 
    option = {
      get_bufnrs = function()
        -- Complete from all loaded buffers (optimized)
        local bufs = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
            bufs[buf] = true
          end
        end
        return vim.tbl_keys(bufs)
      end,
      max_item_count = 3, -- Further limit buffer completions for performance
    }
  },
  { name = 'path', priority = 250, group_index = 2 },
  { name = 'ctags', priority = 100, group_index = 3 },
}

-- Custom formatting with icons and source labels
M.formatting = {
  format = function(entry, vim_item)
    local lspkind = require('lspkind')
    
    -- Custom icon mappings
    local kind_icons = {
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
    }
    
    -- Source labels
    local source_labels = {
      buffer = "[Buffer]",
      nvim_lsp = "[LSP]",
      luasnip = "[Snippet]",
      nvim_lua = "[Lua]",
      path = "[Path]",
      ctags = "[Tags]",
      cmp_yanky = "[Yanky]",
    }
    
    -- Apply icon
    vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind] or "", vim_item.kind)
    
    -- Apply source label
    vim_item.menu = source_labels[entry.source.name] or string.format("[%s]", entry.source.name)
    
    -- Truncate long items
    local max_width = math.floor(0.45 * vim.o.columns)
    if string.len(vim_item.abbr) > max_width then
      vim_item.abbr = string.sub(vim_item.abbr, 1, max_width) .. "..."
    end
    
    return vim_item
  end
}

-- Enhanced sorting with Copilot prioritization
M.sorting = {
  priority_weight = 2,
  comparators = function()
    local comparators = {
      require('cmp.config.compare').offset,
      require('cmp.config.compare').exact,
      require('cmp.config.compare').score,
      require('cmp.config.compare').recently_used,
      require('cmp.config.compare').locality,
      require('cmp.config.compare').kind,
      require('cmp.config.compare').sort_text,
      require('cmp.config.compare').length,
      require('cmp.config.compare').order,
    }
    
    -- Removed Copilot comparator
    
    return comparators
  end,
}

-- Key mappings for completion and snippets
M.get_mappings = function(cmp, luasnip)
  return cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ 
      behavior = cmp.ConfirmBehavior.Replace,
      select = true 
    }),
    
    -- Enhanced Tab/S-Tab for completion and snippets
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
  })
end

-- Command line completion setups
M.setup_cmdline = function(cmp)
  -- Search completion
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Command completion
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })
end

-- DAP completion setup  
M.setup_dap = function(cmp)
  cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
      { name = "dap" },
    },
  })
end

-- Buffer-aware completion enabling
M.setup_conditional = function(cmp)
  cmp.setup({
    enabled = function()
      return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
          or require("cmp_dap").is_dap_buffer()
    end
  })
end

return M
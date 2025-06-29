return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  enabled = true, -- Re-enabled for note taking workflow
  cmd = {
    "ObsidianOpen",
    "ObsidianNew",
    "ObsidianQuickSwitch",
    "ObsidianFollowLink",
    "ObsidianBacklinks",
    "ObsidianToday",
    "ObsidianYesterday",
    "ObsidianTomorrow",
    "ObsidianTemplate",
    "ObsidianSearch",
    "ObsidianLink",
    "ObsidianLinkNew",
    "ObsidianWorkspace",
    "ObsidianPasteImg",
    "ObsidianRename",
    "ObsidianTags",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("obsidian").setup({
      workspaces = {
        {
          name = "zettelkasten",
          path = "~/zettelkasten",
        },
        {
          name = "work",
          path = "~/work-notes",
        },
      },

      -- Configure note ID generation for Zettelkasten
      note_id_func = function(title)
        -- Create note IDs in Zettelkasten format: YYYYMMDDHHMMSS
        local timestamp = os.date("%Y%m%d%H%M%S")
        if title ~= nil then
          -- If title is given, create ID with timestamp prefix
          return timestamp .. "-" .. title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If no title, just use timestamp
          return timestamp
        end
      end,

      -- Note path generation
      note_path_func = function(spec)
        -- Store notes in year/month folders for better organization
        local path = spec.dir / os.date("%Y/%m") / spec.id
        return path:with_suffix(".md")
      end,

      -- Daily notes configuration
      daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
        alias_format = "%B %-d, %Y",
        template = "daily-note.md",
      },

      -- Templates folder
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {
          yesterday = function()
            return os.date("%Y-%m-%d", os.time() - 86400)
          end,
          tomorrow = function()
            return os.date("%Y-%m-%d", os.time() + 86400)
          end,
        },
      },

      -- Key mappings
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle check-boxes
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        -- Smart action depending on context
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },

      -- Customize link style
      wiki_link_func = function(opts)
        if opts.id == nil then
          return string.format("[[%s]]", opts.label)
        elseif opts.label ~= opts.id then
          return string.format("[[%s|%s]]", opts.id, opts.label)
        else
          return string.format("[[%s]]", opts.id)
        end
      end,

      -- Customize note frontmatter
      note_frontmatter_func = function(note)
        -- Add metadata automatically
        local out = { 
          id = note.id, 
          aliases = note.aliases, 
          tags = note.tags,
          created = os.date("%Y-%m-%d %H:%M"),
          modified = os.date("%Y-%m-%d %H:%M"),
        }
        
        -- Ensure fields are kept in array format
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        
        return out
      end,

      -- UI configuration
      ui = {
        enable = true,
        update_debounce = 200,
        -- Checkboxes
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
          [">"] = { char = "", hl_group = "ObsidianRightArrow" },
          ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
          ["!"] = { char = "", hl_group = "ObsidianImportant" },
        },
        -- External link icon
        external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        -- Reference text
        reference_text = { hl_group = "ObsidianRefText" },
        highlight_text = { hl_group = "ObsidianHighlightText" },
        tags = { hl_group = "ObsidianTag" },
        block_ids = { hl_group = "ObsidianBlockID" },
        hl_groups = {
          ObsidianTodo = { bold = true, fg = "#f78c6c" },
          ObsidianDone = { bold = true, fg = "#89ddff" },
          ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
          ObsidianTilde = { bold = true, fg = "#ff5370" },
          ObsidianImportant = { bold = true, fg = "#d73128" },
          ObsidianBullet = { bold = true, fg = "#89ddff" },
          ObsidianRefText = { underline = true, fg = "#c792ea" },
          ObsidianExtLinkIcon = { fg = "#c792ea" },
          ObsidianTag = { italic = true, fg = "#89ddff" },
          ObsidianBlockID = { italic = true, fg = "#89ddff" },
          ObsidianHighlightText = { bg = "#75662e" },
        },
      },

      -- Completion configuration
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },

      -- Picker configuration
      picker = {
        name = "telescope.nvim",
        mappings = {
          new = "<C-x>",
          insert_link = "<C-l>",
        },
      },

      -- Attachments
      attachments = {
        img_folder = "assets/images",
        img_name_func = function()
          return string.format("%s-", os.date("%Y%m%d%H%M%S"))
        end,
        img_text_func = function(client, path)
          path = client:vault_relative_path(path) or path
          return string.format("![%s](%s)", path.name, path)
        end,
      },

      -- Additional options
      follow_url_func = function(url)
        vim.fn.jobstart({"xdg-open", url})
      end,
      
      -- Open notes in splits
      open_notes_in = "current",
      
      -- Sort search results by modified time
      sort_by = "modified",
      sort_reversed = true,
      
      -- Disable frontmatter updates on save (for performance)
      disable_frontmatter = false,
    })

    -- Global keymaps for Obsidian
    vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<cr>", { desc = "New Obsidian note" })
    vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<cr>", { desc = "Open in Obsidian app" })
    vim.keymap.set("n", "<leader>of", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Quick switch notes" })
    vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", { desc = "Show backlinks" })
    vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianTags<cr>", { desc = "Search tags" })
    vim.keymap.set("n", "<leader>od", "<cmd>ObsidianToday<cr>", { desc = "Today's daily note" })
    vim.keymap.set("n", "<leader>oy", "<cmd>ObsidianYesterday<cr>", { desc = "Yesterday's daily note" })
    vim.keymap.set("n", "<leader>om", "<cmd>ObsidianTomorrow<cr>", { desc = "Tomorrow's daily note" })
    vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<cr>", { desc = "Search in vault" })
    vim.keymap.set("n", "<leader>ol", "<cmd>ObsidianLink<cr>", { desc = "Link to existing note" })
    vim.keymap.set("n", "<leader>oL", "<cmd>ObsidianLinkNew<cr>", { desc = "Link to new note" })
    vim.keymap.set("n", "<leader>oe", "<cmd>ObsidianTemplate<cr>", { desc = "Insert template" })
    vim.keymap.set("n", "<leader>or", "<cmd>ObsidianRename<cr>", { desc = "Rename note" })
    vim.keymap.set("n", "<leader>ow", "<cmd>ObsidianWorkspace<cr>", { desc = "Switch workspace" })
    vim.keymap.set("n", "<leader>op", "<cmd>ObsidianPasteImg<cr>", { desc = "Paste image" })

    -- Visual mode mappings
    vim.keymap.set("v", "<leader>ol", "<cmd>ObsidianLink<cr>", { desc = "Link selection" })
    vim.keymap.set("v", "<leader>oL", "<cmd>ObsidianLinkNew<cr>", { desc = "Link selection to new" })
  end,
}

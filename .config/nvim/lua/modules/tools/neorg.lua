return {
  "nvim-neorg/neorg",
  lazy = true,
  ft = "norg",
  version = "*",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("neorg").setup {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              main = "~/Nueroweb",
            },
            default_workspace = "main",
          },
        },
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.integrations.nvim-cmp"] = {},
        ["core.keybinds"] = {
          config = {
            default_keybinds = true,
            neorg_leader = "<LocalLeader>",
            hook = function(keybinds)
              -- Remap todo keybinds to be more accessible
              keybinds.remap_event("norg", "n", "<LocalLeader>tt", "core.qol.todo_items.todo.task_cycle")
              keybinds.remap_event("norg", "n", "<LocalLeader>tu", "core.qol.todo_items.todo.task_undone") 
              keybinds.remap_event("norg", "n", "<LocalLeader>tc", "core.qol.todo_items.todo.task_cancelled")
              keybinds.remap_event("norg", "n", "<LocalLeader>th", "core.qol.todo_items.todo.task_on_hold")
              keybinds.remap_event("norg", "n", "<LocalLeader>ti", "core.qol.todo_items.todo.task_important")
              keybinds.remap_event("norg", "n", "<LocalLeader>tr", "core.qol.todo_items.todo.task_recurring")
            end,
          },
        },
        ["core.export"] = {},
        ["core.export.markdown"] = {},
        ["core.summary"] = {},
        ["core.journal"] = {
          config = {
            strategy = "flat",
            workspace = "main",
          },
        },
        ["core.qol.todo_items"] = {
          config = {
            create_todo_parents = true,
            create_todo_items = true,
          },
        },
        ["core.qol.toc"] = {},
        ["core.looking-glass"] = {},
      },
    }

    -- Neorg Navigation keybindings
    vim.keymap.set("n", "<leader>nw", ":Neorg workspace ", { desc = "Switch Neorg workspace" })
    vim.keymap.set("n", "<leader>ni", ":Neorg index<CR>", { desc = "Open Neorg index" })
    vim.keymap.set("n", "<leader>nr", ":Neorg return<CR>", { desc = "Return from Neorg" })
    vim.keymap.set("n", "<leader>nj", ":Neorg journal today<CR>", { desc = "Open today's journal" })
    vim.keymap.set("n", "<leader>ny", ":Neorg journal yesterday<CR>", { desc = "Open yesterday's journal" })
    vim.keymap.set("n", "<leader>nt", ":Neorg journal tomorrow<CR>", { desc = "Open tomorrow's journal" })

    -- Task Management keybindings
    vim.keymap.set("n", "<leader>tC", function()
      local line = vim.api.nvim_get_current_line()
      local task_desc = vim.fn.input("Task description: ", line:match("- %[ %] (.*)") or "")
      if task_desc ~= "" then
        local project = vim.fn.input("Project (default: neorg): ", "neorg")
        if project == "" then project = "neorg" end
        
        local priority = vim.fn.input("Priority (H/M/L, optional): ")
        local due_date = vim.fn.input("Due date (YYYY-MM-DD, optional): ")
        local tags = vim.fn.input("Tags (+tag1 +tag2, optional): ")
        
        local cmd = "task add " .. vim.fn.shellescape(task_desc) .. " project:" .. project
        
        if priority ~= "" and (priority == "H" or priority == "M" or priority == "L") then
          cmd = cmd .. " priority:" .. priority
        end
        
        if due_date ~= "" then
          cmd = cmd .. " due:" .. due_date
        end
        
        if tags ~= "" then
          cmd = cmd .. " " .. tags
        end
        
        vim.fn.system(cmd)
        vim.notify("Task created: " .. task_desc .. " (project: " .. project .. ")", vim.log.levels.INFO)
      end
    end, { desc = "Create task from line" })

    vim.keymap.set("n", "<leader>tl", function()
      vim.cmd("terminal task list")
    end, { desc = "List tasks" })

    vim.keymap.set("n", "<leader>tp", function()
      vim.cmd("terminal task project:neorg list")
    end, { desc = "List Neorg project tasks" })

    vim.keymap.set("n", "<leader>td", function()
      local task_id = vim.fn.input("Task ID to complete: ")
      if task_id ~= "" then
        vim.fn.system("task " .. task_id .. " done")
        vim.notify("Task " .. task_id .. " completed!", vim.log.levels.INFO)
      end
    end, { desc = "Mark task done" })

    vim.keymap.set("n", "<leader>tm", function()
      local task_id = vim.fn.input("Task ID to modify: ")
      if task_id ~= "" then
        local modification = vim.fn.input("Modification: ")
        if modification ~= "" then
          vim.fn.system("task " .. task_id .. " modify " .. vim.fn.shellescape(modification))
          vim.notify("Task " .. task_id .. " modified", vim.log.levels.INFO)
        end
      end
    end, { desc = "Modify task" })

    -- Quick task creation (minimal prompts)
    vim.keymap.set("n", "<leader>tq", function()
      local line = vim.api.nvim_get_current_line()
      local task_desc = vim.fn.input("Quick task: ", line:match("- %[ %] (.*)") or "")
      if task_desc ~= "" then
        vim.fn.system("task add " .. vim.fn.shellescape(task_desc) .. " project:neorg")
        vim.notify("Quick task created: " .. task_desc, vim.log.levels.INFO)
      end
    end, { desc = "Quick task creation" })

    -- Project-based task lists
    vim.keymap.set("n", "<leader>tP", function()
      local project = vim.fn.input("Show tasks for project: ")
      if project ~= "" then
        vim.cmd("terminal task project:" .. project .. " list")
      end
    end, { desc = "List tasks by project" })

    -- Note attachment for tasks
    vim.keymap.set("n", "<leader>tn", function()
      local task_id = vim.fn.input("Task ID to add note: ")
      if task_id ~= "" then
        local note_option = vim.fn.confirm("Choose note type:", "&1 Annotation\n&2 Link to file\n&3 Create dedicated note", 1)
        
        if note_option == 1 then
          -- Add annotation
          local annotation = vim.fn.input("Annotation: ")
          if annotation ~= "" then
            vim.fn.system("task " .. task_id .. " annotate " .. vim.fn.shellescape(annotation))
            vim.notify("Annotation added to task " .. task_id, vim.log.levels.INFO)
          end
          
        elseif note_option == 2 then
          -- Link to existing file
          local file_path = vim.fn.input("File path: ", "", "file")
          if file_path ~= "" then
            local abs_path = vim.fn.expand(file_path)
            vim.fn.system("task " .. task_id .. " annotate 'Note: " .. abs_path .. "'")
            vim.notify("File link added to task " .. task_id, vim.log.levels.INFO)
          end
          
        elseif note_option == 3 then
          -- Create dedicated note file using jq for robust JSON parsing (single call for efficiency)
          local jq_query = "'.[0] | {desc: (.description // \"task_" .. task_id .. "\"), project: (.project // \"none\"), priority: (.priority // \"none\"), status: (.status // \"pending\")} | \"\\(.desc)|\\(.project)|\\(.priority)|\\(.status)\"'"
          local task_info = vim.fn.system("task " .. task_id .. " export 2>/dev/null | jq -r " .. jq_query):gsub("\n", "")
          
          local task_desc, task_project, task_priority, task_status
          if task_info and task_info ~= "" then
            local parts = vim.split(task_info, "|")
            task_desc = parts[1] or "task_" .. task_id
            task_project = parts[2] or "none"
            task_priority = parts[3] or "none"
            task_status = parts[4] or "pending"
          else
            task_desc = "task_" .. task_id
            task_project = "none"
            task_priority = "none"
            task_status = "pending"
          end
          
          -- Check if task exists
          if task_desc == "task_" .. task_id then
            vim.notify("Task " .. task_id .. " not found, creating note with defaults", vim.log.levels.WARN)
          end
          
          -- Create notes directory if it doesn't exist
          local notes_dir = vim.fn.expand("~/Nueroweb/task_notes")
          vim.fn.mkdir(notes_dir, "p")
          
          -- Create note file
          local note_file = notes_dir .. "/" .. task_id .. "_" .. task_desc:gsub("[^%w%s]", ""):gsub("%s+", "_"):lower() .. ".norg"
          
          -- Create note content
          local note_content = string.format([[
@document.meta
title: Task %s - %s
description: Detailed notes for task %s
authors: %s
categories: [task-notes]
created: %s
task_id: %s
@end

* Task: %s

** Task Details
- ID: %s
- Project: %s
- Priority: %s
- Status: %s

** Detailed Notes

*** Background


*** Requirements


*** Implementation Steps
- [ ] Step 1
- [ ] Step 2
- [ ] Step 3

*** Resources


*** Notes


** Related Files


** Next Actions

]], 
            task_id, task_desc, task_id, 
            os.getenv("USER") or "user",
            os.date("%Y-%m-%d"),
            task_id,
            task_desc,
            task_id,
            task_project,
            task_priority,
            task_status
          )
          
          -- Write file
          local file = io.open(note_file, "w")
          if file then
            file:write(note_content)
            file:close()
            
            -- Add annotation with file link
            vim.fn.system("task " .. task_id .. " annotate 'Note file: " .. note_file .. "'")
            
            -- Open the file
            vim.cmd("edit " .. note_file)
            vim.notify("Created and opened note file for task " .. task_id, vim.log.levels.INFO)
          else
            vim.notify("Failed to create note file", vim.log.levels.ERROR)
          end
        end
      end
    end, { desc = "Add note to task" })

    -- View task annotations
    vim.keymap.set("n", "<leader>ta", function()
      local task_id = vim.fn.input("Task ID to view annotations: ")
      if task_id ~= "" then
        vim.cmd("terminal task " .. task_id .. " information")
      end
    end, { desc = "View task annotations" })

    -- Open task note file
    vim.keymap.set("n", "<leader>to", function()
      local task_id = vim.fn.input("Task ID to open note: ")
      if task_id ~= "" then
        local notes_dir = vim.fn.expand("~/Nueroweb/task_notes")
        local note_files = vim.fn.glob(notes_dir .. "/" .. task_id .. "_*.norg", 0, 1)
        
        if #note_files > 0 then
          vim.cmd("edit " .. note_files[1])
        else
          -- Check for annotation with file path using jq
          local file_annotation = vim.fn.system("task " .. task_id .. " export 2>/dev/null | jq -r '.[0].annotations[]? | select(.description | test(\"^Note file: |^Note: \")) | .description' | head -1"):gsub("\n", "")
          
          if file_annotation ~= "" then
            file_annotation = file_annotation:gsub("^Note file: ", ""):gsub("^Note: ", "")
          else
            file_annotation = nil
          end
          
          if file_annotation and vim.fn.filereadable(file_annotation) == 1 then
            vim.cmd("edit " .. file_annotation)
          else
            vim.notify("No note file found for task " .. task_id, vim.log.levels.WARN)
          end
        end
      end
    end, { desc = "Open task note file" })
    
    -- Set LocalLeader for Neorg files and add debug keybindings
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "norg",
      callback = function()
        vim.g.maplocalleader = ","
        
        -- Debug LocalLeader setup
        vim.notify("Neorg file loaded. LocalLeader should be: " .. (vim.g.maplocalleader or "NOT SET"), vim.log.levels.INFO)
        
        -- Simple test that should always work
        vim.keymap.set("n", ",simple", function()
          vim.notify("Simple comma test works!", vim.log.levels.INFO)
        end, { buffer = true, desc = "Simple test" })
        
        -- Test multiple LocalLeader formats
        vim.keymap.set("n", ",test", function()
          vim.notify("Direct comma test works!", vim.log.levels.INFO)
        end, { buffer = true, desc = "Test comma directly" })
        
        vim.keymap.set("n", "<LocalLeader>test", function()
          vim.notify("LocalLeader test works! LocalLeader = " .. (vim.g.maplocalleader or "NONE"), vim.log.levels.INFO)
        end, { buffer = true, desc = "Test LocalLeader" })
        
        -- Check what LocalLeader is actually set to
        vim.keymap.set("n", ",check", function()
          vim.notify("Current LocalLeader: " .. (vim.g.maplocalleader or "NOT SET"), vim.log.levels.INFO)
          vim.notify("Current Leader: " .. (vim.g.mapleader or "NOT SET"), vim.log.levels.INFO)
        end, { buffer = true, desc = "Check leader settings" })
        
        -- Helper function to safely call Neorg todo functions
        local function safe_todo_call(func_name)
          local ok, neorg = pcall(require, "neorg")
          if not ok then
            vim.notify("Neorg not loaded", vim.log.levels.ERROR)
            return
          end
          
          local todo_module = neorg.modules.loaded_modules["core.qol.todo_items"]
          if not todo_module then
            vim.notify("Todo module not loaded", vim.log.levels.ERROR)
            return
          end
          
          local func = todo_module.public[func_name]
          if not func then
            vim.notify("Function " .. func_name .. " not found", vim.log.levels.ERROR)
            return
          end
          
          local success, err = pcall(func)
          if not success then
            vim.notify("Error calling " .. func_name .. ": " .. tostring(err), vim.log.levels.ERROR)
          end
        end
        
        -- Direct comma keybindings using Neorg Plug mappings
        vim.keymap.set("n", ",tt", "<Plug>(neorg.qol.todo-items.todo.task-cycle)", { buffer = true, desc = "Toggle todo" })
        vim.keymap.set("n", ",td", "<Plug>(neorg.qol.todo-items.todo.task-done)", { buffer = true, desc = "Mark done" })
        vim.keymap.set("n", ",tu", "<Plug>(neorg.qol.todo-items.todo.task-undone)", { buffer = true, desc = "Mark undone" })
        vim.keymap.set("n", ",tc", "<Plug>(neorg.qol.todo-items.todo.task-cancelled)", { buffer = true, desc = "Mark cancelled" })
        vim.keymap.set("n", ",th", "<Plug>(neorg.qol.todo-items.todo.task-on_hold)", { buffer = true, desc = "Mark on hold" })
        vim.keymap.set("n", ",ti", "<Plug>(neorg.qol.todo-items.todo.task-important)", { buffer = true, desc = "Mark important" })
        vim.keymap.set("n", ",tr", "<Plug>(neorg.qol.todo-items.todo.task-recurring)", { buffer = true, desc = "Mark recurring" })
        vim.keymap.set("n", ",tp", "<Plug>(neorg.qol.todo-items.todo.task-pending)", { buffer = true, desc = "Mark pending" })
        
        -- LocalLeader versions (if LocalLeader works) using Plug mappings
        vim.keymap.set("n", "<LocalLeader>tt", "<Plug>(neorg.qol.todo-items.todo.task-cycle)", { buffer = true, desc = "Toggle todo (LocalLeader)" })
        vim.keymap.set("n", "<LocalLeader>td", "<Plug>(neorg.qol.todo-items.todo.task-done)", { buffer = true, desc = "Mark done (LocalLeader)" })
        vim.keymap.set("n", "<LocalLeader>tu", "<Plug>(neorg.qol.todo-items.todo.task-undone)", { buffer = true, desc = "Mark undone (LocalLeader)" })
        vim.keymap.set("n", "<LocalLeader>tc", "<Plug>(neorg.qol.todo-items.todo.task-cancelled)", { buffer = true, desc = "Mark cancelled (LocalLeader)" })
        vim.keymap.set("n", "<LocalLeader>th", "<Plug>(neorg.qol.todo-items.todo.task-on_hold)", { buffer = true, desc = "Mark on hold (LocalLeader)" })
        vim.keymap.set("n", "<LocalLeader>ti", "<Plug>(neorg.qol.todo-items.todo.task-important)", { buffer = true, desc = "Mark important (LocalLeader)" })
        vim.keymap.set("n", "<LocalLeader>tr", "<Plug>(neorg.qol.todo-items.todo.task-recurring)", { buffer = true, desc = "Mark recurring (LocalLeader)" })
        vim.keymap.set("n", "<LocalLeader>tp", "<Plug>(neorg.qol.todo-items.todo.task-pending)", { buffer = true, desc = "Mark pending (LocalLeader)" })
      end,
    })
  end,
}

-- snippets/init.lua

local M = {}

-- Load all snippets and set them up with LuaSnip
function M.setup()
    local ls = require("luasnip")
    local types = require("luasnip.util.types")
    
    -- Configure LuaSnip
    ls.config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = false,
        ext_opts = {
            [types.choiceNode] = {
                active = {
                    virt_text = { { "●", "GruvboxOrange" } }
                }
            }
        }
    })
    
    -- Clear any existing snippets
    ls.cleanup()
    
    -- Load friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()
    
    -- Load custom snippets
    local laravel = require("utils.snippets.laravel")
    local vue = require("utils.snippets.vue")
    
    -- Register snippets
    ls.add_snippets("php", laravel)
    ls.add_snippets("blade", laravel)
    ls.add_snippets("vue", vue)
    
    -- Add filetype extensions
    ls.filetype_extend("typescript", { "vue" })
    ls.filetype_extend("javascript", { "vue" })
    ls.filetype_extend("vue", { "html" })
    
    -- Add common snippets available in all filetypes
    ls.add_snippets("all", {
        ls.snippet("date", {
            ls.function_node(function() return os.date("%Y-%m-%d") end, {})
        }),
        ls.snippet("cl", {
            ls.text_node("console.log("),
            ls.insert_node(1, "value"),
            ls.text_node(");")
        }),
        -- Simple test snippet that should work in any file
        ls.snippet("test", {
            ls.text_node("This is a test snippet!"),
        })
    })
    
    vim.notify("Snippets loaded successfully")
end

-- Function to reload snippets
function M.reload()
    -- Unload snippet modules
    package.loaded["utils.snippets.laravel"] = nil
    package.loaded["utils.snippets.vue"] = nil
    
    -- Re-setup the snippets
    M.setup()
    
    vim.notify("Snippets reloaded successfully")
end

-- Set up key mappings for LuaSnip
function M.setup_keymaps()
    local ls = require("luasnip")
    
    -- Tab to expand and jump forward in snippet
    vim.keymap.set({ "i", "s" }, "<Tab>", function()
        if ls.expand_or_jumpable() then
            return ls.expand_or_jump()
        else
            return "<Tab>"
        end
    end, { expr = true, silent = true })
    
    -- Shift+Tab to jump backward in snippet
    vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
        if ls.jumpable(-1) then
            return ls.jump(-1)
        else
            return "<S-Tab>"
        end
    end, { expr = true, silent = true })
end

-- Setup snippets and keymaps immediately
M.setup()
M.setup_keymaps()

vim.api.nvim_create_user_command("SnippetsReload", function()
    M.reload()
end, {})

return M
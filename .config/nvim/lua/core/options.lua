-- Set vim options
local options = {
    relativenumber = true,
    encoding = "utf-8",
    foldexpr = "",
    hidden = true,
    number = true,
    hlsearch = false,
    shiftwidth = 2,
    tabstop = 2,
    softtabstop = 2,
    autoindent = true,
    smartindent = true,
    expandtab = true,
    completeopt = { "menuone", "menu", "noselect" },
    wildignorecase = true,
    --wildmode = { "longest", "list", "full" },
    ignorecase=true,
    conceallevel = 0,
    concealcursor = "vin",
    cursorline = true,
    cursorlineopt = "number",
    pumheight = 15,
    scrolloff = 8,
    sidescrolloff = 8,
    updatetime = 200,
    undofile = true,
    splitbelow = true,
    splitright = true,
    swapfile = false,
    signcolumn = "yes",
    showmode = false,
    colorcolumn = '120',
    showtabline = 2, -- Always show tabline
}

-- Apply options
for k, v in pairs(options) do
    vim.opt[k] = v
end

-- Session options for taboo.vim to remember tab names
vim.opt.sessionoptions:append({ "tabpages", "globals" })

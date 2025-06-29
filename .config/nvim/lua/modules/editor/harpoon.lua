return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { 
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope.nvim" },
    },
    config = function()
        require("harpoon").setup()
    end,
    keys = {
        { '<leader>ha', '<cmd>lua require("harpoon"):list():add()<cr>' },
        { '<C-e>', '<cmd>lua require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())<cr>' },

        { '<leader>h', '<cmd>lua require("harpoon"):list():select(vim.v.count1)<cr>' },

        -- Toggle previous & next buffers stored within Harpoon list
        { '<C-S-P>', '<cmd>lua require("harpoon"):list():prev()<cr>' },
        { '<C-S-N>', '<cmd>lua require("harpoon"):list():next()<cr>' },
    },
}

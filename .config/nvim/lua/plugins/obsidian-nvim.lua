return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",  -- or use a pinned version
  lazy = false,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "nuero-web",
        path = "~/NueroWeb", -- or your actual vault path
      },
    },
  },
}

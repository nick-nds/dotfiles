return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "olimorris/neotest-phpunit",
    "praem90/neotest-docker-phpunit.nvim",
  },
  config = function()
    -- require("neotest").setup({
    --   run = {
    --     neotest = "-v",
    --     phpunit = "--colors=always",
    --     docker = "--colors=always",
    --   },
    --   adapters = {
    --     require('neotest-docker-phpunit')({
    --       phpunit_cmd = "neotest-docker-phpunit",
    --       docker_phpunit = {
    --         ["237-complete-model-factories"] = {
    --           container   = "php83",
    --           volume      = "/home/lockhart/web-server/www/php83/api.farmd.test/237-complete-model-factories:/app/api.farmd.test/237-complete-model-factories",
    --           standalone  = true,
    --         },
    --         default = {
    --           container   = "phpunit",
    --           volume      = "/source/dir:/docker/work/dir",
    --           standalone  = false,
    --           callback    = function (spec, args)
    --               return spec
    --           end
    --         }
    --       }
    --     }),
    --   }
    -- })
  end
}

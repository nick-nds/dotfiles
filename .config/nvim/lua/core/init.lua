-- Core configuration module
-- Loads options and keymaps

local M = {}

function M.setup()
  require('core.options')
  require('core.keymaps')
end

return M
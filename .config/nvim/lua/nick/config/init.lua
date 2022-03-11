local M = {}

function M:load()
    require "nick.config.keymaps"
    require "nick.config.options".load_options()


	--require "nick.config.plugins.symbols_outline"
	--require "nick.config.plugins.nvim_tree"
	--require "nick.config.plugins.nvim_cmp"

end

return M

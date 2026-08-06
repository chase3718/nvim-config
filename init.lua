-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local repo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", repo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({ { "Error cloning lazy.nvim:\n", "ErrorMsg" }, { out, "WarningMsg" } }, true, {})
		return
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.start_time = vim.fn.reltime()
vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Disable Neovim's built-in directory browser
vim.g.loaded_nvim_dir_plugin = 1

-- Load config modules
require("config.opts")
require("config.remaps")
require("config.autocmds")

-- Setup plugins (every file in lua/plugins/ is auto-loaded by lazy.nvim)
require("lazy").setup("plugins", {
	checker = { enabled = false },
	install = { colorscheme = { "gruvbox" } },
})

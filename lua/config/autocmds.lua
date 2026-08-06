-- Disable automatic comment on newline
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
	vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- Restore cursor position on file open
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
	local line = vim.fn.line("'\"")
	if line > 1 and line <= vim.fn.line("$") then
		vim.cmd("normal! g'\"")
		end
		end,
})

-- Track startup time
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
	local startuptime = vim.fn.reltimefloat(vim.fn.reltime(vim.g.start_time))
	vim.g.startup_time_ms = string.format("%.2f ms", startuptime * 1000)
	end,
})

-- Toggle relative line numbers intelligently
local numgroup = vim.api.nvim_create_augroup("relative_numbers", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
	pattern = "*",
	group = numgroup,
	callback = function()
	if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
		vim.opt.relativenumber = true
		end
		end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
	pattern = "*",
	group = numgroup,
	callback = function()
	if vim.o.nu then
		vim.opt.relativenumber = false
		-- Workaround for https://github.com/neovim/neovim/issues/32068
		if not vim.tbl_contains({ "@", "-" }, vim.v.event.cmdtype) then
			vim.cmd("redraw")
			end
			end
			end,
})

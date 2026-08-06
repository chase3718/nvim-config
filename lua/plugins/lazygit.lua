return {
	{
		"kdheepak/lazygit.nvim",
		cmd = { "LazyGit", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<CR>", desc = "Open LazyGit" },
			{ "<leader>gf", "<cmd>LazyGitCurrentFile<CR>", desc = "Current file" },
			{ "<leader>gh", "<cmd>LazyGitFilterCurrentFile<CR>", desc = "History of current file" },
			{ "<leader>gH", "<cmd>LazyGitFilter<CR>", desc = "Current branch history" },
		},
		init = function()
		vim.g.lazygit_floating_window_border_chars = {
			"╭", "─", "╮", "│", "╯", "─", "╰", "│",
		}
		vim.g.lazygit_floating_window_use_plenary = 0
		vim.g.lazygit_use_neovim_remote = 0
		end,
	},
}

return {
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
		opts = {
			default_file_explorer = true,
			view_options = { show_hidden = true },
			win_options = { signcolumn = "yes:2" },
		},
		keys = {
			{ "-", "<cmd>Oil<CR>", desc = "Open parent directory" },
			{ "<leader>e", "<cmd>Oil<CR>", desc = "File explorer" },
		},
	},
}

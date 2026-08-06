return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "modern",
			delay = 300,
			icons = {
				breadcrumb = "»",
				separator = "➜",
				group = "+",
			},
			win = {
				border = "rounded",
			},
			layout = {
				height = { min = 4, max = 25 },
				width = { min = 20, max = 50 },
				spacing = 3,
				align = "left",
			},
			spec = {
				{ "<leader>f", group = "find", icon = "󰈞" },
				{ "<leader>g", group = "git", icon = "󰊢" },
				{ "<leader>l", group = "lsp", icon = "󰒋" },
				{ "<leader>e", group = "explorer", icon = "󰙅" },
				{ "<leader>x", group = "diagnostics", icon = "󰒡" },
			},
		},
	},
}

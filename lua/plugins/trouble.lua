return {
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		keys = {
			{ "<leader>xx", function() require("trouble").toggle("diagnostics") end, desc = "Diagnostics" },
			{ "<leader>xX", function()
				require("trouble").toggle("diagnostics", { filter = { buf = 0 } })
				end, desc = "Buffer diagnostics" },
				{ "<leader>xr", function() require("trouble").toggle("lsp_references") end, desc = "LSP references" },
				{ "<leader>xs", function() require("trouble").toggle("symbols") end, desc = "Document symbols" },
				{ "<leader>xq", function() require("trouble").toggle("qflist") end, desc = "Quickfix list" },
				{ "<leader>xl", function() require("trouble").toggle("loclist") end, desc = "Location list" },
				{ "<leader>ld", "<cmd>Trouble lsp_definitions toggle<CR>", desc = "LSP definitions" },
				{ "<leader>li", "<cmd>Trouble lsp_implementations toggle<CR>", desc = "LSP implementations" },
				{ "<leader>lt", "<cmd>Trouble lsp_type_definitions toggle<CR>", desc = "LSP type definitions" },
		},
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			{ "nvim-mini/mini.icons", version = "*" },
		},
		opts = {
			auto_close = true,
			auto_preview = true,
			focus = false,
			follow = true,
			restore = true,
			win = {
				type = "split",
				position = "bottom",
				size = 12,
				border = "rounded",
			},
			icons = {
				indent = {
					fold_open = "▾",
					fold_closed = "▸",
				},
			},
			modes = {
				diagnostics = {
					mode = "diagnostics",
					win = { position = "bottom", size = 12 },
				},
				symbols = {
					mode = "lsp_document_symbols",
					win = { position = "right", size = 50 },
				},
				lsp = {
					mode = "lsp",
					win = { position = "bottom", size = 12 },
				},
			},
		},
	},

	-- mini.icons (also used by trouble)
	{
		"nvim-mini/mini.icons",
		version = "*",
		lazy = true,
	},

	-- nvim-web-devicons
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
	},
}

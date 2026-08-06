return {
	{
		"ibhagwan/fzf-lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			{ "junegunn/fzf", build = "./install --bin" },
		},
		cmd = "FzfLua",
		keys = {
			{
				"<leader>ff",
				function()
					require("fzf-lua").files()
				end,
				desc = "Find files",
			},
			{
				"<leader>fF",
				function()
					require("fzf-lua").files({ cmd = [[fd --type f --color=never --hidden --no-ignore]] })
				end,
				desc = "Find all files",
			},
			{
				"<leader>fg",
				function()
					require("fzf-lua").live_grep()
				end,
				desc = "Live grep",
			},
			{
				"<leader>fG",
				function()
					require("fzf-lua").live_grep({
						rg_opts = [[--column --line-number --no-heading --color=always --smart-case --hidden --no-ignore]],
					})
				end,
				desc = "Live grep all",
			},
			{
				"<leader>fb",
				function()
					require("fzf-lua").buffers()
				end,
				desc = "Find buffers",
			},
			{
				"<leader>fr",
				function()
					require("fzf-lua").oldfiles()
				end,
				desc = "Recent files",
			},
			{
				"<leader>fR",
				function()
					require("fzf-lua").resume()
				end,
				desc = "Resume fzf",
			},
			{
				"<leader>fh",
				function()
					require("fzf-lua").helptags()
				end,
				desc = "Help tags",
			},
			{
				"<leader>fc",
				function()
					require("fzf-lua").commands()
				end,
				desc = "Commands",
			},
			{
				"<leader>fk",
				function()
					require("fzf-lua").keymaps()
				end,
				desc = "Keymaps",
			},
			{
				"<leader>fs",
				function()
					require("fzf-lua").search_history()
				end,
				desc = "Search history",
			},
			{
				"<leader>gs",
				function()
					require("fzf-lua").git_status()
				end,
				desc = "Git status",
			},
			{
				"<leader>gb",
				function()
					require("fzf-lua").git_branches()
				end,
				desc = "Git branches",
			},
			{
				"<leader>gc",
				function()
					require("fzf-lua").git_commits()
				end,
				desc = "Git commits",
			},
			{
				"<leader>gd",
				function()
					require("fzf-lua").git_diff()
				end,
				desc = "Git diff",
			},
			{
				"<leader>lr",
				function()
					require("fzf-lua").lsp_references()
				end,
				desc = "LSP references",
			},
			{
				"<leader>ls",
				function()
					require("fzf-lua").lsp_document_symbols()
				end,
				desc = "Document symbols",
			},
			{
				"<leader>lw",
				function()
					require("fzf-lua").lsp_workspace_symbols()
				end,
				desc = "Workspace symbols",
			},
			{
				"<leader>la",
				function()
					require("fzf-lua").lsp_code_actions()
				end,
				desc = "Code actions",
			},
		},
		opts = {
			winopts = {
				height = 0.85,
				width = 0.80,
				row = 0.35,
				col = 0.50,
				border = "rounded",
				preview = {
					default = "bat",
				},
			},
			files = {
				prompt = "Files> ",
				cmd = [[fd --type f --color=never --exclude .git]],
				fd_opts = [[--color=never --type f --no-hidden --exclude .git]],
			},
			grep = {
				prompt = "Rg> ",
				rg_opts = [[--column --line-number --no-heading --color=always --smart-case --glob "!.git/**"]],
			},
			buffers = {
				prompt = "Buffers> ",
				sort_lastused = true,
			},
			fzf_opts = {
				["--layout"] = "reverse",
			},
		},
	},
}

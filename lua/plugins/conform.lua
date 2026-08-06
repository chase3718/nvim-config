return {
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		cmd = { "ConformInfo" },
		keys = {
			{
				"<C-s>",
				function()
					local mode = vim.api.nvim_get_mode().mode
					if mode:sub(1, 1) == "i" then
						vim.cmd.stopinsert()
					end
					require("conform").format({
						lsp_format = "fallback",
						async = false,
						timeout_ms = 3000,
					})
					vim.cmd.write()
				end,
				mode = { "n", "i", "v" },
				desc = "Format and save",
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "goimports", "gofmt" },
				rust = { "rustfmt" },
				python = { "ruff_fix", "ruff_format" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				less = { "prettier" },
				json = { "prettier" },
				jsonc = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				zsh = { "shfmt" },
			},
			format_on_save = false,
			notify_on_error = true,
			formatters = {
				prettier = {
					prepend_args = { "--cache" },
				},
			},
		},
	},
}

return {
	"mfussenegger/nvim-lint",
	event = {
		"BufReadPre",
		"BufNewFile",
	},
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			markdown = { "markdownlint" },
			quarto = { "markdownlint" },
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			python = { "ruff" },
			lua = { "luacheck" },
		}

		-- Overriding args replaces nvim-lint's defaults entirely, so --stdin has
		-- to be kept: without it markdownlint gets no input, prints its usage
		-- text and reports nothing. --fix is dropped because it cannot apply to
		-- stdin, and rewriting files behind the buffer's back is unsafe anyway.
		lint.linters.markdownlint.args = {
			"--stdin",
			"--disable",
			"MD013",
			"--",
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}

return {
	"goolord/alpha-nvim",
	event = "VimEnter",

	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.header.val = vim.split(vim.fn.system("fortune | cowsay -f tux -W 80 "), "\n")

		dashboard.section.buttons.val = {
			dashboard.button("f", "  Find File", "<cmd>FzfLua files<CR>"),
			dashboard.button("g", "  Live Grep", "<cmd>FzfLua live_grep<CR>"),
			dashboard.button("r", "  Recent Files", "<cmd>FzfLua oldfiles<CR>"),
			dashboard.button("b", "󰈔  Buffers", "<cmd>FzfLua buffers<CR>"),

			dashboard.button("n", "  New File", "<cmd>ene | startinsert<CR>"),

			dashboard.button("e", "  Explorer", function()
				require("mini.files").open(vim.loop.cwd(), true)
			end),

			dashboard.button("c", "  Config", "<cmd>edit $MYVIMRC<CR>"),

			dashboard.button("s", "  Restore Session", "<cmd>lua require('persistence').load()<CR>"),

			dashboard.button("m", "  Mason", "<cmd>Mason<CR>"),
			dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<CR>"),
			dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
		}

		for _, button in ipairs(dashboard.section.buttons.val) do
			button.opts.hl = "AlphaButtons"
			button.opts.hl_shortcut = "AlphaShortcut"
		end

		dashboard.section.header.opts.hl = "AlphaHeader"
		dashboard.section.buttons.opts.hl = "AlphaButtons"
		dashboard.section.footer.opts.hl = "AlphaFooter"

		dashboard.section.footer.opts.width = 120
		dashboard.section.header.opts.width = 120

		dashboard.opts.layout[1].val = 1
		dashboard.opts.layout[3].val = 1

		-- Handle `nvim .` before Alpha starts
		local argc = vim.fn.argc()

		if argc == 1 then
			local arg = vim.fn.argv(0)

			if vim.fn.isdirectory(arg) == 1 then
				vim.cmd.cd(vim.fn.fnameescape(arg))

				-- Remove the directory argument so Alpha thinks no file was opened
				vim.cmd.argdelete("*")
			end
		end

		alpha.setup(dashboard.opts)

		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			once = true,
			callback = function()
				local ok, lazy = pcall(require, "lazy")
				if not ok then
					return
				end

				local stats = lazy.stats()

				dashboard.section.footer.val =
					string.format("⚡ Loaded %d/%d plugins in %.2f ms", stats.loaded, stats.count, stats.startuptime)

				pcall(vim.cmd.AlphaRedraw)
			end,
		})
	end,
}

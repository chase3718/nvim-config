return {
	"goolord/alpha-nvim",
	lazy = false,

	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		--------------------------------------------------
		-- Header
		--------------------------------------------------

		dashboard.section.header.val = vim.split(vim.fn.system("fortune | cowsay -f tux -W 80"), "\n")

		--------------------------------------------------
		-- Buttons
		--------------------------------------------------

		dashboard.section.buttons.val = {
			dashboard.button("f", "  Find File", "<cmd>FzfLua files<CR>"),

			dashboard.button("g", "  Live Grep", "<cmd>FzfLua live_grep<CR>"),

			dashboard.button("r", "  Recent Files", "<cmd>FzfLua oldfiles<CR>"),

			dashboard.button("b", "󰈔  Buffers", "<cmd>FzfLua buffers<CR>"),

			dashboard.button("m", "  Mini Files", function()
				require("mini.files").open(vim.uv.cwd(), true)
			end),

			dashboard.button("c", "  Config", "<cmd>edit $MYVIMRC<CR>"),

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

		--------------------------------------------------
		-- Layout
		--------------------------------------------------

		dashboard.opts.layout = {
			{ type = "padding", val = 1 },
			dashboard.section.header,

			{ type = "padding", val = 2 },
			dashboard.section.buttons,

			{ type = "padding", val = 1 },
			dashboard.section.footer,
		}

		--------------------------------------------------
		-- Setup Alpha
		--------------------------------------------------

		alpha.setup(dashboard.opts)

		--------------------------------------------------
		-- Always start with Alpha
		--------------------------------------------------

		vim.api.nvim_create_autocmd("VimEnter", {
			once = true,

			callback = function()
				local argc = vim.fn.argc()

				-- nvim
				if argc == 0 then
					vim.schedule(function()
						alpha.start(false)
					end)

					return
				end

				-- nvim .
				if argc == 1 then
					local arg = vim.fn.argv(0)

					if vim.fn.isdirectory(arg) == 1 then
						vim.cmd.cd(vim.fn.fnameescape(arg))

						vim.schedule(function()
							alpha.start(false)
						end)
					end
				end
			end,
		})

		--------------------------------------------------
		-- Return to Alpha when no real buffers exist
		--------------------------------------------------

		vim.api.nvim_create_autocmd("BufDelete", {
			callback = function()
				vim.schedule(function()
					local has_file = false

					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						if
							vim.api.nvim_buf_is_valid(buf)
							and vim.api.nvim_buf_is_loaded(buf)
							and vim.bo[buf].buflisted
							and vim.bo[buf].filetype ~= "alpha"
							and vim.api.nvim_buf_get_name(buf) ~= ""
						then
							has_file = true
							break
						end
					end

					if not has_file then
						alpha.start(false)
					end
				end)
			end,
		})

		--------------------------------------------------
		-- Quick return home
		--------------------------------------------------

		vim.keymap.set("n", "<leader>h", function()
			alpha.start(false)
		end, {
			desc = "Open Alpha Dashboard",
		})

		--------------------------------------------------
		-- Lazy stats footer
		--------------------------------------------------

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

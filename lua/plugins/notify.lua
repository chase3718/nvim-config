return {
	"rcarriga/nvim-notify",
	lazy = false,
	config = function()
		local notify = require("notify")

		notify.setup({
			background_colour = "#000000",

			fps = 60,

			timeout = 3000,

			stages = "fade_in_slide_out",

			render = "default",

			max_width = function()
				return math.floor(vim.o.columns * 0.5)
			end,

			max_height = function()
				return math.floor(vim.o.lines * 0.4)
			end,

			on_open = function(win)
				vim.api.nvim_win_set_config(win, {
					border = "rounded",
				})
			end,

			icons = {
				ERROR = "",
				WARN = "",
				INFO = "",
				DEBUG = "",
				TRACE = "✎",
			},
		})

		vim.notify = notify

		vim.keymap.set("n", "<leader>fn", function()
			local notify = require("notify")
			local fzf = require("fzf-lua")

			local history = notify.history()

			local entries = {}

			for i, item in ipairs(history) do
				table.insert(entries, {
					idx = i,
					text = string.format("[%s] %s", item.level, item.message:gsub("\n", " ")),
				})
			end

			fzf.fzf_exec(
				vim.tbl_map(function(x)
					return x.text
				end, entries),
				{
					prompt = "Notifications> ",
					previewer = false,
				}
			)
		end, {
			desc = "Notification History",
		})
	end,
}

return {
	"numToStr/FTerm.nvim",
	config = function()
		require("FTerm").setup({
			border = "single", -- Options: 'single', 'double', 'shadow', etc.
			dimensions = {
				height = 0.8, -- Height of the terminal (80%)
				width = 0.8, -- Width of the terminal (80%)
				x = 0.5, -- X position (centered)
				y = 0.5, -- Y position (centered)
			},
		})

		-- Keybindings to toggle the terminal open and closed
		vim.keymap.set("n", "<A-/>", "<CMD>lua require('FTerm').toggle()<CR>")
		vim.keymap.set("t", "<A-/>", "<C-\\><C-n><CMD>lua require('FTerm').toggle()<CR>")
	end,
}

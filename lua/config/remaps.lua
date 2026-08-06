vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- File explorer (built-in, no plugin)
vim.keymap.set("n", "<leader>e", function()
	require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
end, { desc = "Open file explorer" })

-- Exit insert mode
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Paste without replacing register
vim.keymap.set("x", "<leader>p", [["_dP]])

-- LSP rename (built-in, no plugin to trigger load)
vim.keymap.set("n", "<leader>lR", vim.lsp.buf.rename, { desc = "Rename symbol" })

vim.keymap.set("n", "<leader>aa", "<cmd>AvanteAsk<CR>", {
	desc = "Avante Ask",
})

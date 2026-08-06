vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- File explorer (built-in, no plugin)
vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = "Open file explorer" })

-- Exit insert mode
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Paste without replacing register
vim.keymap.set("x", "<leader>p", [["_dP]])

-- LSP rename (built-in, no plugin to trigger load)
vim.keymap.set("n", "<leader>lR", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- luacheck configuration for this Neovim config.
-- Without this, luacheck (run via nvim-lint) flags every `vim.*` call as
-- "accessing undefined variable 'vim'".

std = "luajit"
cache = true

-- Declared as a writable global rather than read_globals: the config assigns
-- to fields like vim.g.mapleader and vim.opt.number, which luacheck would
-- otherwise report as "setting a read-only field of global vim".
globals = { "vim" }

-- Neovim plugin specs and callbacks routinely take args they don't use.
unused_args = false

return {
  "ellisonleao/gruvbox.nvim",
  -- Colorschemes shouldn't be lazy-loaded: the theme needs to be applied
  -- during startup, and priority puts it ahead of other non-lazy plugins.
  lazy = false,
  priority = 1000,
  opts = {
    terminal_colors = true, -- recolor kitty's 16 ANSI colors to match
    contrast = "", -- "hard" | "soft" | "" for the default
    transparent_mode = false,
    bold = true,
    italic = {
      strings = false, -- ComicShannsMono has no italic face; kitty would
      comments = false, -- synthesize a slant, which reads poorly
      folds = true,
      emphasis = true,
      operators = false,
    },
    overrides = {},
  },
  config = function(_, opts)
    require("gruvbox").setup(opts)
    vim.o.background = "dark"
    vim.cmd.colorscheme("gruvbox")
  end,
}

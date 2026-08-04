-- Nerd Font glyphs, written as \u{...} escapes rather than literal characters
-- so they survive copy/paste and any editor that mangles the private use area.
-- Codepoints match the LazyVim icon set.
local kind_icons = {
  Array         = "\u{ea8a} ",
  Boolean       = "\u{f0a19} ",
  Class         = "\u{eb5b} ",
  Color         = "\u{eb5c} ",
  Constant      = "\u{f03ff} ",
  Constructor   = "\u{f423} ",
  Enum          = "\u{f15d} ",
  EnumMember    = "\u{f15d} ",
  Event         = "\u{ea86} ",
  Field         = "\u{f02b} ",
  File          = "\u{ea7b} ",
  Folder        = "\u{e5ff} ",
  Function      = "\u{f0295} ",
  Interface     = "\u{f0e8} ",
  Key           = "\u{ea93} ",
  Keyword       = "\u{eb62} ",
  Method        = "\u{f0295} ",
  Module        = "\u{f487} ",
  Namespace     = "\u{f09ae} ",
  Null          = "\u{e299} ",
  Number        = "\u{f03a0} ",
  Object        = "\u{ea8b} ",
  Operator      = "\u{eb64} ",
  Package       = "\u{f487} ",
  Property      = "\u{f02b} ",
  Reference     = "\u{eb36} ",
  Snippet       = "\u{f113d} ",
  String        = "\u{eab1} ",
  Struct        = "\u{f01bc} ",
  Text          = "\u{ea93} ",
  TypeParameter = "\u{ea92} ",
  Unit          = "\u{ea96} ",
  Value         = "\u{ea93} ",
  Variable      = "\u{f002b} ",
}

return {
  "hrsh7th/nvim-cmp",
  version = false, -- last release is way too old
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
  },
  opts = function()
    -- LSP capabilities are registered in lua/plugins/lsp.lua, which loads on
    -- BufReadPre -- i.e. before servers start. Doing it here would be too late.
    local cmp = require("cmp")
    local defaults = require("cmp.config.default")()
    local auto_select = true

    return {
      completion = {
        completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
      },
      preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
      snippet = {
        expand = function(item)
          vim.snippet.expand(item.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = auto_select }),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        -- Accept and replace the text to the right of the cursor
        ["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = auto_select }),
        ["<C-CR>"] = function(fallback)
          cmp.abort()
          fallback()
        end,
        ["<Tab>"] = function(fallback)
          if vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          else
            fallback()
          end
        end,
        ["<S-Tab>"] = function(fallback)
          if vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
          else
            fallback()
          end
        end,
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "path" },
      }, {
        { name = "buffer" },
      }),
      formatting = {
        format = function(entry, item)
          if kind_icons[item.kind] then
            item.kind = kind_icons[item.kind] .. item.kind
          end

          local widths = {
            abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
            menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
          }

          for key, width in pairs(widths) do
            if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
              item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
            end
          end

          return item
        end,
      },
      sorting = defaults.sorting,
    }
  end,
}

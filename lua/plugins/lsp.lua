return {
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog", "MasonUpdate" },
    build = ":MasonUpdate",
    opts = {
      ui = { border = "rounded" },
    },
    config = function(_, opts)
      require("mason").setup(opts)

      -- Linters used by nvim-lint. mason-lspconfig's ensure_installed only
      -- covers language servers, and mason itself has no equivalent option
      -- for standalone tools, so install them off the registry directly.
      -- ruff rather than pylint: pylint's mason package needs python >= 3.10
      -- and this machine only has the system 3.9. ruff ships as a standalone
      -- binary, so it has no interpreter requirement.
      local ensure_installed = { "ruff", "eslint_d", "markdownlint" }
      local registry = require("mason-registry")
      registry.refresh(function()
        for _, name in ipairs(ensure_installed) do
          local ok, pkg = pcall(registry.get_package, name)
          if ok and not pkg:is_installed() then
            pkg:install()
          end
        end
      end)
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Advertise nvim-cmp's completion capabilities to every server.
      -- This has to run before vim.lsp.enable(), so it lives here rather
      -- than in the nvim-cmp spec (which only loads on InsertEnter).
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      -- Per-server overrides. These are merged on top of the defaults that
      -- nvim-lspconfig ships in its own lsp/<name>.lua files.
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            diagnostics = { globals = { "vim" } },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config("pyright", {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      vim.lsp.config("yamlls", {
        settings = {
          yaml = { keyOrdering = false },
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "ts_ls",
          "marksman",
          "jdtls",
          "jsonls",
          "yamlls",
          "bashls",
        },
        -- Installed servers are handed to vim.lsp.enable() automatically.
        -- ruff is excluded: it's installed as a linter for nvim-lint, and
        -- letting mason-lspconfig also start it as a language server would
        -- report every Python diagnostic twice.
        automatic_enable = { exclude = { "ruff" } },
      })

      vim.diagnostic.config({
        severity_sort = true,
        virtual_text = { spacing = 2, prefix = "\u{2022}" },
        float = { border = "rounded", source = true },
        -- Escapes rather than literal glyphs; see the note in nvim-cmp.lua.
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "\u{f057} ",
            [vim.diagnostic.severity.WARN] = "\u{f071} ",
            [vim.diagnostic.severity.INFO] = "\u{f05a} ",
            [vim.diagnostic.severity.HINT] = "\u{f0eb} ",
          },
        },
      })

      -- Neovim 0.11+ already maps grn (rename), gra (code action),
      -- grr (references), gri (implementation), grt (type definition),
      -- K (hover) and gO (document symbols). Only the gaps are added here.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local function map(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", vim.lsp.buf.definition, "Goto definition")
          map("gD", vim.lsp.buf.declaration, "Goto declaration")
          map("<leader>e", vim.diagnostic.open_float, "Line diagnostics")
          map("<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, "Format buffer")
        end,
      })
    end,
  },
}

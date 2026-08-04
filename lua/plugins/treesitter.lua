return {

    -- Treesitter is a new parser generator tool that we can
    -- use in Neovim to power faster and more accurate
    -- syntax highlighting.
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        commit = vim.fn.has("nvim-0.12") == 0 and "7caec274fd19c12b55902a5b795100d21531391f" or nil,
        version = false,
        build = function()
            local TS = require("nvim-treesitter")
            if not TS.get_installed then
                vim.notify("Please restart Neovim and run `:TSUpdate` to use the `nvim-treesitter` **main** branch.",
                    vim.log.levels.ERROR)
                return
            end
            TS.update(nil, { summary = true })
        end,
        event = "VeryLazy",
        cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
        opts_extend = { "ensure_installed" },
        opts = {
            indent = { enable = true },
            highlight = { enable = true },
            folds = { enable = true },
            ensure_installed = {
                "bash",
                "c",
                "diff",
                "html",
                "javascript",
                "jsdoc",
                "json",
                "lua",
                "luadoc",
                "luap",
                "markdown",
                "markdown_inline",
                "printf",
                "python",
                "query",
                "regex",
                "toml",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "xml",
                "yaml",
            },
        },
        config = function(_, opts)
            local TS = require("nvim-treesitter")

            -- some quick sanity checks
            if not TS.get_installed then
                vim.notify("Please update `nvim-treesitter`", vim.log.levels.ERROR)
                return
            elseif type(opts.ensure_installed) ~= "table" then
                vim.notify("`nvim-treesitter` opts.ensure_installed must be a table", vim.log.levels.ERROR)
                return
            end

            -- setup treesitter (this handles ensure_installed automatically)
            TS.setup(opts)

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("nvim_treesitter", { clear = true }),
                callback = function(ev)
                    local ft = ev.match
                    local lang = vim.treesitter.language.get_lang(ft)

                    -- highlighting
                    if opts.highlight.enable ~= false then
                        pcall(vim.treesitter.start, ev.buf, lang)
                    end

                    -- indents
                    if opts.indent.enable ~= false then
                        vim.opt_local.indentexpr = "v:lua.vim.treesitter.indent()"
                        vim.opt_local.smartindent = false
                    end

                    -- folds
                    if opts.folds.enable ~= false then
                        vim.opt_local.foldmethod = "expr"
                        vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    end
                end,
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        event = "VeryLazy",
        opts = {
            move = {
                enable = true,
                set_jumps = true,
            },
        },
        config = function(_, opts)
            local TS = require("nvim-treesitter-textobjects")
            if not TS.setup then
                vim.notify("Please update `nvim-treesitter-textobjects`", vim.log.levels.ERROR)
                return
            end
            TS.setup(opts)

            local function attach(buf)
                local ft = vim.bo[buf].filetype
                if not (vim.tbl_get(opts, "move", "enable")) then
                    return
                end
                local moves = vim.tbl_get(opts, "move", "keys") or {}

                for method, keymaps in pairs(moves) do
                    for key, query in pairs(keymaps) do
                        local queries = type(query) == "table" and query or { query }
                        local parts = {}
                        for _, q in ipairs(queries) do
                            local part = q:gsub("@", ""):gsub("%..*", "")
                            part = part:sub(1, 1):upper() .. part:sub(2)
                            table.insert(parts, part)
                        end
                        local desc = table.concat(parts, " or ")
                        desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
                        desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
                        vim.keymap.set({ "n", "x", "o" }, key, function()
                            if vim.wo.diff and key:find("[cC]") then
                                return vim.cmd("normal! " .. key)
                            end
                            require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
                        end, {
                            buffer = buf,
                            desc = desc,
                            silent = true,
                        })
                    end
                end
            end

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("nvim_treesitter_textobjects", { clear = true }),
                callback = function(ev)
                    attach(ev.buf)
                end,
            })
            vim.tbl_map(attach, vim.api.nvim_list_bufs())
        end,
        keys = {
            { "]f", desc = "Next function start" },
            { "]F", desc = "Next function end" },
            { "[f", desc = "Prev function start" },
            { "[F", desc = "Prev function end" },
            { "]c", desc = "Next class start" },
            { "}C", desc = "Next class end" },
            { "[c", desc = "Prev class start" },
            { "[C", desc = "Prev class end" },
            { "]a", desc = "Next parameter start" },
            { "]A", desc = "Next parameter end" },
            { "[a", desc = "Prev parameter start" },
            { "[A", desc = "Prev parameter end" },
        },
    },

    -- Automatically add closing tags for HTML and JSX
    {
        "windwp/nvim-ts-autotag",
        event = "VeryLazy",
        opts = {},
    },
}

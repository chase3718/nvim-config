-- Leader key set in lazy.lua, before plugin loading

-- Basic remaps
vim.keymap.set("n", "<leader>x", vim.cmd.Ex, { desc = "Open file explorer" })

-- Resolve prettier, preferring a project-local install over the global one so
-- repos that pin their own version get formatted with it. Walks up from the
-- file's directory looking for node_modules/.bin/prettier.
local function resolve_prettier(filepath)
    local dir = filepath ~= "" and vim.fs.dirname(filepath) or vim.uv.cwd()

    while dir do
        local candidate = dir .. "/node_modules/.bin/prettier"
        if vim.fn.executable(candidate) == 1 then
            return candidate, true
        end
        local parent = vim.fs.dirname(dir)
        if parent == dir then
            break
        end
        dir = parent
    end

    if vim.fn.executable("prettier") == 1 then
        return "prettier", false
    end
    return nil, false
end

-- Format + Save (Ctrl-s)
vim.keymap.set({ "n", "i" }, "<C-s>", function()
    -- leave insert mode so formatting doesn't fight typing
    if vim.fn.mode() == "i" then
        vim.cmd.stopinsert()
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local filepath = vim.api.nvim_buf_get_name(bufnr)
    local filetype = vim.bo[bufnr].filetype

    -- File types that prettier supports
    local prettier_filetypes = {
        javascript = true,
        javascriptreact = true,
        typescript = true,
        typescriptreact = true,
        vue = true,
        css = true,
        scss = true,
        less = true,
        html = true,
        json = true,
        jsonc = true,
        yaml = true,
        markdown = true,
        graphql = true,
        handlebars = true,
    }

    local prettier_cmd = prettier_filetypes[filetype] and resolve_prettier(filepath) or nil

    if prettier_cmd and filepath ~= "" then
        -- Write the buffer once, after formatting, rather than saving first and
        -- reloading from disk. Prettier reads the buffer over stdin, so the file
        -- only changes on disk a single time per <C-s>.
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local input = table.concat(lines, "\n")
        if vim.bo[bufnr].eol then
            input = input .. "\n"
        end

        local max_size = 1024 * 1024 -- 1MB in bytes
        if #input > max_size then
            vim.notify(
                string.format("Buffer too large for Prettier (%.1f MB). Saving without formatting.",
                    #input / (1024 * 1024)),
                vim.log.levels.WARN
            )
            local ok, err = pcall(vim.cmd, "write")
            if not ok then
                vim.notify("Failed to save file: " .. tostring(err), vim.log.levels.ERROR)
            end
            return
        end

        -- Save the buffer as-is if formatting can't be applied, so <C-s> always
        -- persists your work regardless of Prettier's outcome.
        local function save_unformatted()
            vim.api.nvim_buf_call(bufnr, function()
                local ok, err = pcall(vim.cmd, "write")
                if not ok then
                    vim.notify("Failed to save file: " .. tostring(err), vim.log.levels.ERROR)
                end
            end)
        end

        local changedtick = vim.api.nvim_buf_get_changedtick(bufnr)

        vim.system(
            { prettier_cmd, "--stdin-filepath", filepath },
            { stdin = input, text = true },
            vim.schedule_wrap(function(result)
                if not vim.api.nvim_buf_is_valid(bufnr) or vim.api.nvim_buf_get_name(bufnr) ~= filepath then
                    return
                end

                -- Typing during the async run invalidates the formatted output,
                -- so keep the newer buffer contents and just save them.
                if vim.api.nvim_buf_get_changedtick(bufnr) ~= changedtick then
                    vim.notify("Buffer was modified during formatting, saving without reformatting",
                        vim.log.levels.WARN)
                    save_unformatted()
                    return
                end

                if result.code ~= 0 then
                    local max_stderr_lines = 10 -- Limit error output to prevent overwhelming popups
                    local stderr_lines = vim.split(result.stderr or "", "\n", { trimempty = true })
                    local truncated = #stderr_lines > max_stderr_lines
                    local error_msg = table.concat(vim.list_slice(stderr_lines, 1, max_stderr_lines), "\n")

                    if error_msg:match("[Hh]eap out of memory") or error_msg:match("FATAL ERROR") then
                        vim.notify(
                            "Prettier ran out of memory formatting this file.\n" ..
                            "File saved but not formatted.\n" ..
                            "Try formatting a smaller section or use LSP formatting instead.",
                            vim.log.levels.ERROR
                        )
                    elseif error_msg:match("SyntaxError") then
                        local syntax_error = error_msg:match("(SyntaxError[^\n]*)")
                        vim.notify(
                            "Prettier formatting failed:\n" .. (syntax_error or "Syntax error in file"),
                            vim.log.levels.WARN
                        )
                    elseif error_msg ~= "" then
                        local display_msg = error_msg
                        if truncated then
                            display_msg = display_msg .. "\n.. (error output truncated)"
                        end
                        vim.notify("File saved but Prettier formatting failed:\n" .. display_msg, vim.log.levels.WARN)
                    else
                        vim.notify("File saved but Prettier formatting failed (unknown error)", vim.log.levels.WARN)
                    end

                    save_unformatted()
                    return
                end

                local formatted = vim.split(result.stdout or "", "\n")
                -- Prettier terminates its output with a newline, which split
                -- turns into a trailing empty element the buffer shouldn't get.
                if formatted[#formatted] == "" then
                    table.remove(formatted)
                end

                if #formatted > 0 and not vim.deep_equal(formatted, lines) then
                    local view = vim.fn.winsaveview()
                    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted)
                    vim.fn.winrestview(view)
                end

                vim.api.nvim_buf_call(bufnr, function()
                    local ok, err = pcall(vim.cmd, "write")
                    if not ok then
                        vim.notify("Failed to save file: " .. tostring(err), vim.log.levels.ERROR)
                    end
                end)
            end)
        )
    else
        -- Fall back to LSP formatting or just save
        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        local can_format = false
        for _, c in ipairs(clients) do
            if c:supports_method("textDocument/formatting") then
                can_format = true
                break
            end
        end

        if can_format then
            -- Format synchronously, then write
            vim.lsp.buf.format({
                bufnr = bufnr,
                async = false,
                timeout_ms = 2000,
            })
            local ok, err = pcall(vim.cmd, "write")
            if not ok then
                vim.notify("Failed to save file: " .. tostring(err), vim.log.levels.ERROR)
            end
        else
            -- No formatter attached: just save. Wrapped like the other two
            -- write sites so an unnamed buffer reports E32 as a notification
            -- rather than throwing a stack trace out of the mapping.
            local ok, err = pcall(vim.cmd, "write")
            if not ok then
                vim.notify("Failed to save file: " .. tostring(err), vim.log.levels.ERROR)
            end
        end
    end
end, { desc = "Format and save" })

vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })

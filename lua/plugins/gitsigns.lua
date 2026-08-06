return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
            },
            current_line_blame = true,
            current_line_blame_opts = { delay = 300 },
        },
        keys = {
            { "]h", function() require("gitsigns").nav_hunk("next") end, desc = "Next hunk" },
            { "[h", function() require("gitsigns").nav_hunk("prev") end, desc = "Prev hunk" },
            { "<leader>hs", function() require("gitsigns").stage_hunk() end, desc = "Stage hunk" },
            { "<leader>hr", function() require("gitsigns").reset_hunk() end, desc = "Reset hunk" },
            { "<leader>hp", function() require("gitsigns").preview_hunk() end, desc = "Preview hunk" },
            { "<leader>hb", function() require("gitsigns").toggle_current_line_blame() end, desc = "Toggle blame" },
        },
    },
}

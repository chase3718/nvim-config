return {
    {
        "morhetz/gruvbox",
        priority = 1000,
        lazy = false,
        init = function()
            vim.g.gruvbox_contrast_dark = "medium"
            vim.g.gruvbox_italic = 1
            vim.g.gruvbox_termcolors = 256
            vim.g.colors_name = "gruvbox"
        end,
        config = function()
            vim.cmd.colorscheme("gruvbox")
        end,
    },
}

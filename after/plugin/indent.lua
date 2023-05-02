require("indent_blankline").setup {
    char = "│",
    show_current_context = true,
    show_end_of_line = false,
    show_current_context_start = false,
    show_trailing_blankline_indent = false,
    use_treesitter = true,
    --filetype_exclude = {},
    vim.api.nvim_set_hl(0, "IndentBlankLineContextChar", {fg = "#FFCCFF", bg = "none"}),
    vim.api.nvim_set_hl(0, "IndentBlankLineChar", {fg = "#666666", bg = "none"})
}



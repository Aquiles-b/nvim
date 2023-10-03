require("ibl").setup ({
    scope = {
        show_start = false,
        show_end = false,
        highlight = { "Function", "Label"},
        -- include = {
            -- node_type = {
                -- ["*"] = {"*"},
            -- },
        -- },
    },

    whitespace = {
        remove_blankline_trail = false,

    },

    exclude = { filetypes = { "txt" } },
})



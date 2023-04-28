require("indent_blankline").setup {
    space_char_blankline = "",
    show_current_context = true,
    show_current_context_start = false,
}
--Cor das linhas de indentação
vim.cmd[[highlight IndentBlanklineChar guifg=#777777 gui=nocombine]]
--Cor das linhas de indentação quando esta no bloco
vim.cmd[[highlight IndentBlanklineContextChar guifg=#FFccFF gui=nocombine]]
--Usar contexto do treesitter
vim.cmd[[let g:indent_blankline_use_treesitter = v:true]]
--Mostar o primeiro nivel de indentação.
vim.cmd[[let g:indent_blankline_show_first_indent_level = v:true]]
--Para tirar indentação em comentários.
vim.cmd[[let g:indent_blankline_max_indent_increase = 1]]
vim.cmd[[let g:indent_blankline_char_list_blankline = ['│', '', '', ''] ]]
vim.cmd[[let g:indent_blankline_char_list = ['│', '│', '┆', '┊'] ]]

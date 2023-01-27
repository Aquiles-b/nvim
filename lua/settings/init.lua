local set = vim.opt
	
set.syntax = 'on' 
set.expandtab = true
set.scrolloff = 8
set.shiftwidth = 4
set.tabstop = 4
set.smarttab = true
set.background = 'dark'
set.rnu = true

set.ignorecase = true
set.hlsearch = false
set.incsearch = true
set.smartcase = true
set.fileencoding = 'utf-8'

set.cursorline = true

set.termguicolors = true

set.hidden = true
set.number = true

vim.cmd([[let g:indentLine_char_list = ['|', '¦', '┆', '┊'] ]])
vim.cmd([[let g:indentLine_setColors = 0]])

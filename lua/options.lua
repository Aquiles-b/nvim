local set = vim.opt
set.syntax = 'on'
set.expandtab = true
set.scrolloff = 8
set.shiftwidth = 4
set.colorcolumn = '80'
set.tabstop = 4
set.smarttab = true
set.background = 'dark'
set.rnu = true

vim.cmd [[set noshowmode]]
set.ignorecase = true
set.hlsearch = false
set.incsearch = true
set.smartcase = true
set.fileencoding = 'utf-8'
set.cursorline = true

set.termguicolors = true

set.hidden = true
set.number = true

vim.cmd([[let g:indentLine_char_list = ['│', '¦', '┆', '┊'] ]])
vim.cmd([[let g:indentLine_setColors = 0]])
vim.opt.numberwidth = 3
vim.opt.statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum) : ''}%=%s"
vim.cmd [[set signcolumn=yes:1]]

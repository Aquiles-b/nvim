local set = vim.opt
set.syntax = 'on'
set.expandtab = true
set.scrolloff = 8
set.shiftwidth = 4
set.colorcolumn = '80'
set.tabstop = 4
set.smarttab = true
set.background = 'dark'
set.nu = true
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

vim.opt.numberwidth = 3
vim.opt.statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum) : ''}%=%s"
vim.opt.signcolumn = "yes:1"

-- Transparent bg
vim.api.nvim_set_hl(0, "Normal", { bg = "none" } )
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" } )
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" } )
vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" } )

set.virtualedit = "block"

-- Folding
set.foldmethod = "expr"
set.foldexpr = "nvim_treesitter#foldexpr()"
set.foldlevel = 999

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

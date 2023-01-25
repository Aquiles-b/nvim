local map = vim.api.nvim_set_keymap
vim.g.mapleader = ' '
local opts = {noremap = true, silent = true}

--replace
vim.keymap.set("n", "<leader>acw", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]])

--Changes 
vim.cmd([[map <Leader>" ysiw"]])
vim.cmd([[map <Leader>' ysiw']])
vim.cmd([[map <Leader>[ ysiw] ]])
vim.cmd([[map <Leader>{ ysiw} ]])
vim.cmd([[map <Leader>( ysiw) ]])
vim.cmd([[map <Leader>tw ysiwt ]])
vim.cmd([[map <Leader>tl ysst ]])
vim.cmd([[map <Leader>d( ds) ]])
vim.cmd([[map <Leader>d[ ds] ]])
vim.cmd([[map <Leader>d{ ds} ]])
vim.cmd([[map <Leader>d' ds' ]])
vim.cmd([[map <Leader>d" ds" ]])

vim.cmd([[vmap ( S) ]])
vim.cmd([[vmap [ S] ]])
vim.cmd([[vmap { S} ]])
vim.cmd([[vmap " S"]])
vim.cmd([[vmap ' S']])
vim.cmd([[vmap t St ]])

--treesitter
map('n', '<leader>tss', ':TSBufToggle highlight<CR>', opts)

--comment
map('n', '<leader>c', ':CommentToggle<CR>', opts)
map('v', '<leader>c', ':CommentToggle<CR>', opts)

--Arquivos
map('n', '<leader>ff', ':Telescope find_files<CR>', opts)
map('n', '<leader>fg', ':Telescope live_grep<CR>', opts)
map('n', '<leader>e', ':NvimTreeToggle<CR>', opts)
map('n', '<leader>w', ':w!<CR>', opts)
map('n', '<leader>q', ':q!<CR>', opts)
--term
map('t', '<C-o>', '<C-\\><C-n>', opts)
map('n', '<A-i>', ':ToggleTerm direction=float<CR>', opts)
map('n', '<A-h>', ':ToggleTerm direction=horizontal size=20<CR>', opts)
map('t', '<A-i>', '<C-c> <cmd>close<CR>', opts)
map('t', '<A-h>', '<C-c> <cmd>close<CR>', opts)
map('t', '<A-m>', 'make run<CR>', opts)
--Movimentacao
map('i', '<A-f>', '<C-o><S-a>', opts)
map('i', '<A-d>', '<C-o><S-i>', opts)
map('i', '<A-l>', '<C-o>l', opts)
map('i', '<A-h>', '<C-o>h', opts)
map('i', '<C-o>', '<Esc>', opts)
map('n', '<C-o>', '<Esc>', opts)
map('v', '<C-o>', '<Esc>', opts)
map('i', '<C-k>', '->', opts)
map('i', '<A-j>', '<Esc>o', opts)
map('i', '<A-;>', '<Esc><S-a>;<Esc>', opts)

map('n', '<C-h>', '<C-w>h', opts)
map('n', '<C-l>', '<C-w>l', opts)
map('n', '<C-k>', '<C-w>k', opts)
map('n', '<C-j>', '<C-w>j', opts)

-- Move to previous/next
map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
-- Re-order to previous/next
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
-- Goto buffer in position...
map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
-- Pin/unpin buffer
map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
-- Close buffer
map('n', '<A-c>', ':bdelete!<CR>', opts)
-- Magic buffer-picking mode
map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)

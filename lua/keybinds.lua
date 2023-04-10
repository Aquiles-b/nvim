local map = vim.api.nvim_set_keymap
vim.g.mapleader = ' '
local opts = {noremap = true, silent = true}

--autoindent
map('n', '₢', "mmgg=G'mzz", opts)
map('n', '©', "mmgg=G'mzz", opts)

--replace
vim.keymap.set("n", "<leader>acw", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]])

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
map('n', '<A-h>', ':ToggleTerm direction=horizontal size=15<CR>', opts)
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
map('n', '<leader>tn', ':set rnu!<CR>', opts)

map('n', '<leader>fe', ':SymbolsOutlineOpen<CR>', opts)

--Mover seleção de código
map('v', '<C-j>', ":m '>+1<CR>gv=gv", opts)
map('v', '<C-k>', ":m '<-2<CR>gv=gv", opts)

map('n', '<C-h>', '<C-w>h', opts)
map('n', '<C-l>', '<C-w>l', opts)
map('n', '<C-k>', '<C-w>k', opts)
map('n', '<C-j>', '<C-w>j', opts)

-- Move to previouse/next
map('n', '<A-l>', ':bnext<CR>', opts)
map('n', '<A-h>', ':bprevious<CR>', opts)
-- Close buffer
map('n', '<A-c>', ':bdelete!<CR>', opts)
-- Magic buffer-picking mode

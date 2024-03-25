local map = vim.api.nvim_set_keymap
vim.g.mapleader = ' '
local opts = {noremap = true, silent = true}

--autoindent altgr+c
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
map('n', '<leader>fg', ':Telescope live_grep_args<CR>', opts)
map('n', '<leader>e', ':NvimTreeToggle<CR>', opts)
map('n', '<leader>w', ':w!<CR>', opts)
map('n', '<leader>q', ':q!<CR>', opts)
--term
map('t', '<C-n>', '<C-\\><C-n>', opts)
map('n', '<A-i>', ':ToggleTerm direction=float<CR>', opts)
map('t', '<A-i>', '<cmd>close<CR>', opts)
--Movimentacao
map('i', '<A-f>', '<C-o><S-a>', opts)
map('i', '<A-d>', '<C-o><S-i>', opts)
map('i', '<A-l>', '<C-o>l', opts)
map('i', '<A-h>', '<C-o>h', opts)
map('i', '<A-L>', '<C-o>w', opts)
map('i', '<A-H>', '<C-o>b', opts)
map('i', '<C-k>', '->', opts)
map('i', '<A-j>', '<Esc>o', opts)
map('i', '<A-;>', '<Esc><S-a>;<Esc>', opts)

map('n', '<leader>fe', '<cmd>Outline<CR>', opts)

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

-- Tabnine
map('n', '<leader>tg', ':TabnineToggle<CR>', opts)

-- Make J and K part of jumplist
vim.keymap.set({"n", "v"}, "j", [[v:count ? (v:count >=3 ? "m'" . v:count : "") . "j" : "j"]], { expr = true })
vim.keymap.set({"n", "v"}, "k", [[v:count ? (v:count >= 3 ? "m'" . v:count : "") . "k" : "k"]], { expr = true })

-- Copilot
vim.g.copilot_no_tab_map = true
vim.keymap.set('i', '<A-m>', 'copilot#Accept("<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.keymap.set('i', '<A-n>', 'copilot#Dismiss()', {
  expr = true,
  replace_keycodes = false
})
vim.cmd [[ function! SuggestOneWord()
    let suggestion = copilot#Accept("")
    let bar = copilot#TextQueuedForInsertion()
    return split(bar, '[ .]\zs')[0]
endfunction ]]
vim.keymap.set('i', '<A-M>', 'SuggestOneWord()', {
  expr = true,
  replace_keycodes = false
})
vim.cmd [[highlight CopilotSuggestion guifg=#777777 ctermfg=8]]

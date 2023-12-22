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

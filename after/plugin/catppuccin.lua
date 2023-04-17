require("catppuccin").load("frappe")

vim.api.nvim_set_hl(0, "Normal", { bg = "none" } )
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" } )
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" } )

vim.cmd[[hi NvimTreeNormal guibg=NONE ctermbg=NONE]]

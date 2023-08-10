local lsp = require('lsp-zero')
lsp.preset('lsp-compe')
lsp.set_preferences({
  sign_icons = {
    error = '│',
    warn  = '│',
    hint  = '│',
    info  = '│'
  }
})

lsp.setup()

local cmp = require('cmp')
local lspkind = require('lspkind')
-- local kind_mapper = {6, 3, 2, 22, 4, 5, 1, 7, 8, 9, 10, 11, 12, 13, 14}

local cmp_config = lsp.defaults.cmp_config({
    window = {
        completion = cmp.config.window.bordered({
            border = "single",
        }),
    },

    sources = {
        {name = "nvim_lsp", keyword_length = 2},
        {name = "luasnip", keyword_length = 2},
        {name = "path", keyword_length = 2},
        {name = "buffer", keyword_length = 3},
        {name = "nvim_lua", keyword_length = 2},
    },
    formatting = {
        fields = {"menu", "abbr", "kind"},
        format = lspkind.cmp_format({
            maxwidth = 20,
            ellipsis_char = '...',

            before = function (entry, vim_item)
                local final = "()"
                vim_item.abbr = vim_item.abbr:match("[^(]+")
                vim_item.abbr = vim_item.abbr:gsub("%s+","")

                if vim_item.kind == "Function" or  vim_item.kind == "Method" then
                vim_item.abbr = vim_item.abbr:gsub("%s+","") .. final
                end
                vim_item.menu = ""
                return vim_item
            end
        }),
    },

    sorting = {
        comparators = {
            cmp.config.compare.exact,
            cmp.config.compare.locality,
        }
    }
})

cmp.setup(cmp_config)

vim.diagnostic.config({
    virtual_text = false,
})

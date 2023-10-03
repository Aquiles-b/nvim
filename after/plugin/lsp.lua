local lsp = require('lsp-zero').preset({})
local cmp = require('cmp')
local lspkind = require('lspkind')

lsp.extend_cmp()

require('mason').setup({})
require('mason-lspconfig').setup({
    handlers = {lsp.default_setup},
})

lsp.set_sign_icons({
    error = '│',
    warn  = '│',
    hint  = '│',
    info  = '│'
})

lsp.setup()


cmp.setup({
    mapping = {
        ['<A-l>'] = cmp.mapping.confirm({select = true}),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    },
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
})

lsp.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp.default_keymaps({buffer = bufnr})
end)

vim.diagnostic.config({
    virtual_text = false,
})

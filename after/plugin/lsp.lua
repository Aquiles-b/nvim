local lsp = require('lsp-zero')
lsp.preset('lsp-compe')

lsp.set_preferences({
  sign_icons = {
    error = '',
    warn = '',
    hint = '',
    info = ''
  }
})

lsp.configure('sumneko_lua', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

lsp.setup()

local cmp = require('cmp')
local lspkind = require('lspkind')

local cmp_config = lsp.defaults.cmp_config({
    window = {
        completion = cmp.config.window.bordered({
            border = "single",
        }),
    },

    sources = {
        {name = "nvim_lsp", keyword_length = 2},
        {name = "luasnip", keyword_length = 2},
        {name = "path", keyword_length = 3},
        {name = "buffer", keyword_length = 3},
        {name = "nvim_lua", keyword_length = 2},
    },
    formatting = {
        fields = {"menu", "abbr", "kind"},
        format = lspkind.cmp_format({
            maxwidth = 50,
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
    virtual_text = true,
})


local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

require("luasnip").add_snippets('c', {
    s('#ip', fmt([[
    #include <stdio.h>
    #include <stdlib.h>
    #include "{}"

    ]], {i(1, "Header")})),

    s('#ib', fmt([[
    #include <stdio.h>

    int main(){{
        {}

        return 0;
    }}
    ]],{i(1)})
    ),

    s('func', fmt([[
    {} {}({}){{
        {}
        return {};
    }}
    ]], {i(1, "tipo"),
            i(2, "nome"),
            i(3, "args"),
            i(4),
            i(5)
        })),

    s('voi', fmt([[
    void {}({}){{
        {}
    }}
    ]], {
            i(1, "nome"),
            i(2, "args"),
            i(3)
        })),

    s('pv', fmt([[
    printf ("%d{}", {});
    ]], { 
            i(1), 
            i(2, "var")
        })),

    s('pt', fmt([[
    printf ("{}\n");
    ]], {i(1)})),

    s('fo', fmt([[
    for ({}; {}; {}){{
        {}
    }}
    ]], {
            i(1, "init"),
            i(2, "cond"),
            i(3, "incr"),
            i(4)
        }))

})

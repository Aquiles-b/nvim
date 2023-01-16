local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.configure('sumneko_lua', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

lsp.set_preferences({
    sign_icons = {}
})

lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
})

local ls = require("luasnip")
local t = ls.text_node
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

require("luasnip").add_snippets('c', {
    s('#padr', fmt([[
    #include <stdio.h>
    #include <stdlib.h>
    #include "{}"

    ]], {i(1, "Header")})),

    s('#ba', fmt([[
    #include <stdio.h>

    int main(){{
        
        return 0;
    }}
    ]],{})
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
    ]], {i(1)}))

   })

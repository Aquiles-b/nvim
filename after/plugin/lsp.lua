local lsp = require('lsp-zero')
lsp.preset('recommended')

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

vim.diagnostic.config({
    virtual_text = true,
})

--cmp configurations
local icons = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "ﰠ",
    Variable = "",
    Class = "ﴯ",
    Interface = "",
    Module = "",
    Property = "ﰠ",
    Unit = "塞",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "פּ",
    Event = "",
    Operator = "",
    TypeParameter = ""
}


vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#c6c6c6"})
    vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#7292fa"})
    vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#40e0d0"})
    vim.api.nvim_set_hl(0, "CmpItemKindConstructor", { fg = "#eee006"})
    vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = "#72fa9b"})
    vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#fe902f"})
    vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = "#9285c9"})
    vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = "#fdfd96"})
    vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = ""})
    vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = ""})
    vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = ""})
    vim.api.nvim_set_hl(0, "CmpItemKindValue", { fg = ""})
    vim.api.nvim_set_hl(0, "CmpItemKindEnum", { fg = ""})
    vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#f94646"})
    vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = "#d073fc"})
    vim.api.nvim_set_hl(0, "CmpItemKindColor", { fg = "#ebebeb"})
    vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = "#ecbbc9"})
    vim.api.nvim_set_hl(0, "CmpItemKindReference", { fg = ""})
    vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = "#d69e17"})
    vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", { fg = ""})
    vim.api.nvim_set_hl(0, "CmpItemKindConstant", { fg = "#e8f388"})
    vim.api.nvim_set_hl(0, "CmpItemKindStruct", { fg = "#ffdb58"})
    vim.api.nvim_set_hl(0, "CmpItemKindEvent", { fg = ""})
    vim.api.nvim_set_hl(0, "CmpItemKindOperator", { fg = ""})
    vim.api.nvim_set_hl(0, "CmpItemKindTypeParameter", { fg = ""})

local cmp = require('cmp')

cmp.setup {
    window = {
        completion = cmp.config.window.bordered({border = "single"}),
    },
    formatting = {
        format = function(_, vim_item)
            vim_item.kind = (icons[vim_item.kind] or "foo") .. " " .. vim_item.kind
            return vim_item
        end,
    },
}

--luasnips

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

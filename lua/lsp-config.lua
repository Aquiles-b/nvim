-- Adjustments -------------------------

vim.filetype.add {
    extension = {
        cl = "c",
    },
}

-- LuaSnip Config --
local ls = require("luasnip")

ls.config.setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").lazy_load { paths = "~/.config/nvim/after/snippets/" }
require("luasnip.loaders.from_vscode").lazy_load()

vim.keymap.set({ "i", "s" }, "<C-l>", function() ls.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-h>", function() ls.jump(-1) end, { silent = true })

-----------------------------------------

-- nvim-cmp --
local cmp = require("cmp")
local lspkind = require('lspkind')

cmp.setup({
    snippet = {
        expand = function(args)
            ls.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<A-l>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
    },
    window = {
        completion = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
        }),
        documentation = cmp.config.window.bordered({
            border = "rounded",
        }),
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

-----------------------------------------

-- Setup Mason --
require("mason").setup({
    ui = {
        icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "",
        },
        height = 0.75,
        border = 'single',
    },
})

-----------------------------------------

---- Lsp Windows ----

-- Border in floating window --
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {} 
  opts.border = opts.border or 'rounded'
  
  return orig_util_open_floating_preview(contents, syntax, opts, ...) 
end

-- Status column --
local signs = { Error = "DiagnosticUnified",
                Warn = "DiagnosticUnified",
                Info = "DiagnosticUnified",
                Hint = "DiagnosticUnified" }
for type, hl in pairs(signs) do
  vim.fn.sign_define("DiagnosticSign" .. type, { text = "│", texthl = hl, numhl = "" })
end

-- Show diagnostic --
local opts = { noremap = true, silent = true }
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)
vim.keymap.set('v', '<F4>', vim.lsp.buf.code_action, opts)
vim.keymap.set("n", "þ", function()
    require("conform").format()
end, { noremap = true, silent = true })

-----------------------------------------

local on_attach = function(client, bufnr)
end

-- Setup LSP with Mason-lspconfig --
local mason_lspconfig = require("mason-lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp") 
-- Catch all installed servers from Mason and configure them 
local installed_servers = mason_lspconfig.get_installed_servers()
local capabilities = cmp_nvim_lsp.default_capabilities() 

for _, server in ipairs(installed_servers) do
    vim.lsp.config(server, {
      on_attach = on_attach,
      capabilities = capabilities,
    })
    vim.lsp.enable(server)
end

local set = vim.opt
set.syntax = 'on'
set.expandtab = true
set.scrolloff = 8
set.colorcolumn = '100'
set.smarttab = true
set.background = 'dark'
set.nu = true
set.rnu = true

set.shiftwidth = 4
set.tabstop = 4

-- ## Indent
local function SetIndentSize(size)
    size = tonumber(size) or 4
    vim.opt.shiftwidth = size
    vim.opt.tabstop = size
    print("Indent size set to " .. size)
end

vim.api.nvim_create_user_command(
    "SetIndent",
    function(opts)
        SetIndentSize(opts.args)
    end,
    { nargs = 1 }
)

-- ## Ltex language
local function set_ltex_language(lang)
    local clients = vim.lsp.get_active_clients({ name = "ltex_plus" })
    if #clients == 0 then
        vim.notify("LTeX is not active for this buffer.", vim.log.levels.WARN)
        return
    end

    for _, client in ipairs(clients) do
        client.config.settings = client.config.settings or {}
        client.config.settings.ltex = client.config.settings.ltex or {}
        client.config.settings.ltex.language = lang
        client.notify("workspace/didChangeConfiguration", {
            settings = client.config.settings,
        })
    end

    vim.notify("LTeX language set to: " .. lang, vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("LtexSetLang", function(opts)
    set_ltex_language(opts.args)
end, {
nargs = 1,
complete = function()
    return { "en-US", "pt-BR" }
end,
})

vim.cmd [[set noshowmode]]
set.ignorecase = true
set.hlsearch = false
set.incsearch = true
set.smartcase = true
set.fileencoding = 'utf-8'
set.cursorline = true

set.termguicolors = true

set.hidden = true
set.number = true

vim.opt.numberwidth = 3
vim.opt.statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum) : ''}%=%s"
vim.opt.signcolumn = "yes:1"

-- Transparent bg
vim.api.nvim_set_hl(0, "Normal", { bg = "none" } )
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" } )
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" } )
vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" } )

set.virtualedit = "block"

-- Folding
set.foldmethod = "expr"
set.foldexpr = "nvim_treesitter#foldexpr()"
set.foldlevel = 999

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

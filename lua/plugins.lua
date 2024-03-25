-- vim:foldmethod=marker:foldlevel=0

-- {{{ Lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
local ok, lazy = pcall(require, 'lazy')
if not ok then return end
-- }}}

lazy.setup({
    -- Colorschemes --
    -- {{{ Catppuccin
    {
        "catppuccin/nvim", 
        lazy = false,
        priority = 1000,
        config = function()
            require("catppuccin").load("frappe")
        end,
    },
    -- }}}
    
    -- HUD --
    -- {{{ Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    disable = { "latex" },
                    additional_vim_regex_highlighting = false,
                },
            })
        end,
    },
    -- }}}
    -- {{{ Treesitter_Context
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "VeryLazy",
        opts = {
            enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
            max_lines = 4, -- How many lines the window should span. Values <= 0 mean no limit.
            trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
            min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
            patterns = {
                -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
                -- For all filetypes
                -- Note that setting an entry here replaces all other patterns for this entry.
                -- By setting the 'default' entry below, you can control which nodes you want to
                -- appear in the context window.
                default = {
                    "class",
                    "function",
                    "method",
                    "for",
                    "while",
                    "if",
                    "switch",
                    "case",
                    "interface",
                    "struct",
                    "enum",
                },
                -- Patterns for specific filetypes
                -- If a pattern is missing, *open a PR* so everyone can benefit.
                tex = {
                    "chapter",
                    "section",
                    "subsection",
                    "subsubsection",
                },
                haskell = {
                    "adt",
                },
                rust = {
                    "impl_item",
                },
                terraform = {
                    "block",
                    "object_elem",
                    "attribute",
                },
                scala = {
                    "object_definition",
                },
                vhdl = {
                    "process_statement",
                    "architecture_body",
                    "entity_declaration",
                },
                markdown = {
                    "section",
                },
                elixir = {
                    "anonymous_function",
                    "arguments",
                    "do_block",
                    "list",
                    "map",
                    "tuple",
                    "quoted_content",
                },
                json = {
                    "pair",
                },
                typescript = {
                    "export_statement",
                },
                yaml = {
                    "block_mapping_pair",
                },
            },
            exact_patterns = {
                -- Example for a specific filetype with Lua patterns
                -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
                -- exactly match "impl_item" only)
                -- rust = true,
            },

            -- [!] The options below are exposed but shouldn't require your attention,
            --     you can safely ignore them.

            zindex = 20, -- The Z-index of the context window
            mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
            -- Separator between context and content. Should be a single character string, like '-'.
            -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
            separator = nil,
        },
    },
    -- }}}
    -- {{{ Lualine
    {
        'nvim-lualine/lualine.nvim',
        opts = {
            options = {
                disabled_filetypes = { statusline = {'packer','NvimTree'} },
                icons_enabled = true,
                theme = 'auto',
                component_separators = { left = '', right = ''},
                section_separators = { left = '', right = ''},
                always_divide_middle = true,
                globalstatus = false,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                }
            },
            sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch', 'diff', 'diagnostics'},
                lualine_c = {'filename'},
                lualine_x = {'encoding', 'fileformat', {'filetype', colored = false}},
                lualine_y = {'progress'},
                lualine_z = {'location'}
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {'filename'},
                lualine_x = {'location'},
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {
                lualine_a = {{
                    'buffers',
                    show_filename_only = true,   -- Shows shortened relative path when set to false.
                    hide_filename_extension = false,   -- Hide filename extension when set to true.
                    show_modified_status = true, -- Shows indicator when the buffer is modified.
                    mode = 4, 
                    -- 0: Shows buffer name
                    -- 1: Shows buffer index
                    -- 2: Shows buffer name + buffer index
                    -- 3: Shows buffer number
                    -- 4: Shows buffer name + buffer number
                    max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
                    -- it can also be a function that returns
                    -- the value of `max_length` dynamically.
                    filetype_names = {
                        TelescopePrompt = 'Telescope',
                        dashboard = 'Dashboard',
                        packer = 'Packer',
                        fzf = 'FZF',
                        alpha = 'Alpha'
                    }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )
                    symbols = {
                        modified = ' ●',      -- Text to show when the buffer is modified
                        alternate_file = '', -- Text to show to identify the alternate file
                        directory =  '',     -- Text to show when the buffer is a directory
                    },
                },
                },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {'tabs'}
            },
            winbar = {},
            inactive_winbar = {},
            extensions = {},

        },
    },
    -- }}}
    -- {{{ Nvim_Devicons
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
        opts = {
            override = {
                zsh = {
                    icon = "",
                    name = "Zsh",
                },
            },
            color_icons = true,
            default = true,
        },
    },
    -- }}}
    -- {{{ indent-blankline
    {
        "lukas-reineke/indent-blankline.nvim",
        main='ibl',
        config = function()
            require("ibl").setup ({
                scope = {
                    show_start = false,
                    show_end = false,
                    highlight = { "Function", "Label"},
                },
                whitespace = {
                    remove_blankline_trail = false,

                },
                exclude = { filetypes = { "txt" } },
            })
        end
    },
    -- }}}
    -- {{{ rainbow-delimiters
    {
        '/HiPhish/rainbow-delimiters.nvim',
    },
    -- }}}
    
    -- Navigation --
    -- {{{ Telescope
    {
        'nvim-telescope/telescope.nvim',
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {"nvim-telescope/telescope-live-grep-args.nvim" , version = "^1.0.0"},
        },
        config = function()
            require("telescope").load_extension("live_grep_args")
            require("telescope").setup()
        end
    },
    -- }}}
    -- {{{ toggleterm
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        opts = {
            direction = "float",
            float_opts = {
                border = "single",
            },
        },
    },
    -- }}}
    -- {{{ Nvim_Tree
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup({
                sort_by = "case_sensitive",
                actions = {
                    open_file = { quit_on_open = true }
                },
                update_focused_file = {
                    enable = true,
                    update_cwd = true
                },
                view = { adaptive_size = true },
                filters = {
                    custom = { '^.git$', '^node_modules$' }
                },
                git = {
                    enable = false
                },
                log = {
                    enable = true,
                    types = {
                        diagnostics = true
                    }
                },
                diagnostics = {
                    enable = true,
                    show_on_dirs = false,
                    debounce_delay = 50,
                    icons = {
                        hint = '│',
                        info = '│',
                        warning = '│',
                        error = '│'
                    }
                }
            })
        end,
    },
    --}}}
    -- {{{ symbols-outline
    {
        "hedyhli/outline.nvim",
        config = function()
            require("outline").setup {}
        end,    
    },
        -- }}}

        -- Auto actions --
        -- {{{ nvim-comment
        {
            "terrortylor/nvim-comment",
            config = function()
                require('nvim_comment').setup({
                    comment_empty = false,
                })
            end,
        },
        -- }}}
        -- {{{ autopairs
        { 
            "windwp/nvim-autopairs",
            config = function()
                require("nvim-autopairs").setup()
            end,
        },
        -- }}}

        -- Autocompletion --
        -- {{{ copilot
        {
            'github/copilot.vim',
        },
        -- }}}
        -- {{{ Nvim_CMP
        {
            "hrsh7th/nvim-cmp",
            dependencies = {
                { "saadparwaiz1/cmp_luasnip" },
                { 'hrsh7th/cmp-nvim-lsp' },
                { 'hrsh7th/cmp-buffer' },
                { 'hrsh7th/cmp-path' },
                { 'hrsh7th/cmp-cmdline' },
                { 'rafamadriz/friendly-snippets' },
                -- {{{ LuaSnip
                {
                    "L3MON4D3/LuaSnip",
                    dependencies = { "rafamadriz/friendly-snippets" },
                    config = function()
                        local ls = require("luasnip")
                        local s = ls.snippet
                        local sn = ls.snippet_node
                        local isn = ls.indent_snippet_node
                        local t = ls.text_node
                        local i = ls.insert_node
                        local f = ls.function_node
                        local c = ls.choice_node
                        local d = ls.dynamic_node
                        local r = ls.restore_node
                        local events = require("luasnip.util.events")
                        local ai = require("luasnip.nodes.absolute_indexer")
                        local extras = require("luasnip.extras")
                        local l = extras.lambda
                        local rep = extras.rep
                        local p = extras.partial
                        local m = extras.match
                        local n = extras.nonempty
                        local dl = extras.dynamic_lambda
                        local fmt = require("luasnip.extras.fmt").fmt
                        local fmta = require("luasnip.extras.fmt").fmta
                        local conds = require("luasnip.extras.expand_conditions")
                        local postfix = require("luasnip.extras.postfix").postfix
                        local types = require("luasnip.util.types")
                        local parse = require("luasnip.util.parser").parse_snippet
                        local ms = ls.multi_snippet
                        local k = require("luasnip.nodes.key_indexer").new_key

                        ls.config.setup({ enable_autosnippets = true })
                        require("luasnip.loaders.from_lua").lazy_load { paths = "~/.config/nvim/after/snippets/" }
                        require("luasnip.loaders.from_vscode").lazy_load()
                        vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
                        vim.keymap.set({"i", "s"}, "<C-D>", function() ls.jump(-1) end, {silent = true})
                    end,
                },
                -- }}}
            },
        },
        -- }}}
        -- {{{ lspkind
        {
            "onsails/lspkind.nvim",
        },
        -- }}}
        -- {{{ Lsp_Zero
        {
            "VonHeikemen/lsp-zero.nvim",
            branch = 'dev-v3',
            lazy = false,
            config = function()
                --- {{{ Configs
                local lsp = require('lsp-zero').preset({})
                lsp.extend_lspconfig()
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

                    sources = cmp.config.sources({
                        {name = "nvim_lsp", keyword_length = 2},
                        {name = "luasnip", keyword_length = 2},
                        {name = "path", keyword_length = 2},
                        {name = "buffer", keyword_length = 3},
                        {name = "nvim_lua", keyword_length = 2},
                    }),
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
                    lsp.default_keymaps({buffer = bufnr})
                end)

                vim.diagnostic.config({
                    virtual_text = false,
                })
                --- }}}
            end,
        },
        -- }}}
        -- {{{ Mason
        {
            "williamboman/mason.nvim",
            opts = {
                ui = {
                    icons = {
                        package_installed = "",
                        package_pending = "",
                        package_uninstalled = "",
                    },
                    height = 0.75,
                    border = 'single',
                },
            },
        },
        -- }}}
        -- {{{ Mason_LSPConfig
        {
            "williamboman/mason-lspconfig.nvim",
        },
        -- }}}
        -- {{{ Nvim_Lspconfig
        {
            "neovim/nvim-lspconfig",
            dependencies = {
                { "hrsh7th/cmp-nvim-lsp" },
            },
        },
        -- }}}

    })

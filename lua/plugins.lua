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
                    disable = {'latex'},
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
                    statusline = 100,
                    tabline = 100,
                    winbar = 100,
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
        -- '/HiPhish/rainbow-delimiters.nvim',
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
                    enable = false,
                    update_cwd = false
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
        -- {{{ LSP + CMP + Mason
        {"hrsh7th/nvim-cmp",
            dependencies = {
                { "saadparwaiz1/cmp_luasnip" },
                { 'hrsh7th/cmp-nvim-lsp' },
                { 'hrsh7th/cmp-buffer' },
                { 'hrsh7th/cmp-path' },
                { 'hrsh7th/cmp-cmdline' },
                { 'rafamadriz/friendly-snippets' },
                {"L3MON4D3/LuaSnip", dependencies = { "rafamadriz/friendly-snippets" }},
            },
        },
        {"onsails/lspkind.nvim"},
        {"williamboman/mason.nvim"},
        {"williamboman/mason-lspconfig.nvim"},
        {"neovim/nvim-lspconfig"},
        -- }}}

    -- Formatting --
        -- {{{ conform
        {
          'stevearc/conform.nvim',
          opts = {},
        },
        -- }}}

    -- Git ---
    -- {{{ gitsigns
    {
      'lewis6991/gitsigns.nvim',
      config = function()
        require('gitsigns').setup {
          signs = {
            add          = { text = '┃' },
            change       = { text = '┃' },
            delete       = { text = '_' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
            untracked    = { text = '┆' },
          },
          signs_staged = {
            add          = { text = '┃' },
            change       = { text = '┃' },
            delete       = { text = '_' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
            untracked    = { text = '┆' },
          },
          signs_staged_enable = true,
          signcolumn = true,
          numhl      = false,
          linehl     = false,
          word_diff  = false,
          watch_gitdir = {
            follow_files = true
          },
          auto_attach = true,
          attach_to_untracked = false,
          current_line_blame = false,
          current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = 'eol',
            delay = 1000,
            ignore_whitespace = false,
            virt_text_priority = 100,
            use_focus = true,
          },
          current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
          sign_priority = 6,
          update_debounce = 100,
          status_formatter = nil,
          max_file_length = 40000,
          preview_config = {
            style = 'minimal',
            relative = 'cursor',
            row = 0,
            col = 1
          },
        }
      end,
    },
    -- }}}
    -- {{{ fugitive
    {
        "tpope/vim-fugitive",
    },
    -- }}}
    -- {{{ Diff.nvim
        {
            "esmuellert/vscode-diff.nvim",
            dependencies = { "MunifTanjim/nui.nvim" },
        },
    -- }}}

    -- Latex -- 
        -- {{{ Vimtex
        {
            "lervag/vimtex",
            lazy = false,
            init = function()
                vim.g.vimtex_view_general_viewer = 'sumatraPDF'
                vim.g.vimtex_view_general_options = '-reuse-instance @pdf'
            end
        },
        -- }}}

    -- Markdown --
        -- {{{ render-markdown
        {
          'MeanderingProgrammer/render-markdown.nvim',
          dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
          -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
          -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
          ---@module 'render-markdown'
          ---@type render.md.UserConfig
          opts = {},
          config = function()
              require('render-markdown').setup({})
          end,
        },
        -- }}}

    -- {{{ Conform
    {
        'stevearc/conform.nvim',
        config = function ()
            require("conform").setup({
                formatters_by_ft = {
                    lua = { "stylua" },
                    -- Conform will run multiple formatters sequentially
                    python = { "black", "isort" },
                    -- Use a sub-list to run only the first available formatter
                    javascript = { { "prettierd", "prettier" } },
                    html = { { "prettierd", "prettier" } },
                    css = { { "prettierd", "prettier" } },
                    xml = { { "xmlformatter" } },
                    c = { { "clangd", "clang-format" } },
                },
            })

            vim.keymap.set("n", "<F3>", [[<Cmd>lua require("conform").format()<CR>]])
        end
    },
    -- }}}

}) -- lazy setup


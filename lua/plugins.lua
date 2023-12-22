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

lazy.setup({
    'github/copilot.vim',
    'nvim-treesitter/nvim-treesitter',
    '/HiPhish/rainbow-delimiters.nvim',
    {"catppuccin/nvim", lazy=false},

    {'nvim-telescope/telescope.nvim',
        dependencies = {
            { 
                "nvim-telescope/telescope-live-grep-args.nvim" ,
                -- This will not install any breaking changes.
                -- For major updates, this must be adjusted manually.
                version = "^1.0.0",
            },
        },
     config = function()
        require("telescope").load_extension("live_grep_args")
      end
    },

    'nvim-lua/plenary.nvim',

    'nvim-tree/nvim-tree.lua',
    'nvim-tree/nvim-web-devicons',
    "akinsho/toggleterm.nvim",
    'nvim-lualine/lualine.nvim',
    'simrat39/symbols-outline.nvim',
    "windwp/nvim-autopairs",
    "terrortylor/nvim-comment",
    {"lukas-reineke/indent-blankline.nvim", main='ibl'},
    "onsails/lspkind.nvim",

    'VonHeikemen/lsp-zero.nvim',
    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    'L3MON4D3/LuaSnip',
    'rafamadriz/friendly-snippets',
})

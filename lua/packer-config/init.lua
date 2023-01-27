local ok, packer = pcall(require, "packer")
if not ok then return end

return packer.startup{function(use)
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use '/p00f/nvim-ts-rainbow'
    use { "catppuccin/nvim", as = "catppuccin" }
    use 'wbthomason/packer.nvim'
    use {
      'nvim-telescope/telescope.nvim', tag = '0.1.0',
      requires = { {'nvim-lua/plenary.nvim'} }
    }
    use 'nvim-tree/nvim-tree.lua'
    use 'nvim-tree/nvim-web-devicons'
    use "akinsho/toggleterm.nvim"
    use 'nvim-lualine/lualine.nvim'
    use 'romgrk/barbar.nvim'
    use 'simrat39/symbols-outline.nvim'
    use "windwp/nvim-autopairs"
    use "terrortylor/nvim-comment"
    use "Yggdroot/indentLine"
    use {
      'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},
            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},
            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    }
end}

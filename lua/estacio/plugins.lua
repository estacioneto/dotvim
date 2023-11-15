-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Git
  use 'tpope/vim-fugitive'

  -- File handling
  use 'mbbill/undotree'

  -- Finding files
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.4',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {
    'junegunn/fzf.vim',
    requires = { 'junegunn/fzf', run = ':call fzf#install()' }
  }

  -- Writing code
  use 'tpope/vim-surround'
  use 'chrisbra/vim-commentary'
  use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  }

  -- LSP
  use { 'neoclide/coc.nvim', branch = 'release', run = 'yarn install' }
  -- LSP Zero: https://github.com/VonHeikemen/lsp-zero.nvim
  use {
    'neovim/nvim-lspconfig',
    requires = {
      --- Uncomment these if you want to manage LSP servers from neovim
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'L3MON4D3/LuaSnip' },
    }
  }

  -- Code tools
  -- See https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
  }
  use 'nvim-treesitter/nvim-treesitter-context'
  use 'github/copilot.vim'

  -- Formatting
  use 'mhartington/formatter.nvim'

  -- Colorschemes
  use 'tomasiser/vim-code-dark'
  use 'marko-cerovac/material.nvim'
  use { 'rose-pine/neovim', as = 'rose-pine' }
  use { "catppuccin/nvim", as = "catppuccin" }

  -- Statusline
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons' }
  }
  use 'arkav/lualine-lsp-progress'
  use {
    'linrongbin16/lsp-progress.nvim',
    config = function()
      require('lsp-progress').setup()
    end
  }

  -- Debugging
  use 'mfussenegger/nvim-dap'
  use 'nvim-telescope/telescope-dap.nvim'
  use 'theHamsta/nvim-dap-virtual-text'
  use 'rcarriga/nvim-dap-ui'

  -- Tips
  use {
    'rcarriga/nvim-notify',
    config = function()
      vim.opt.termguicolors = true
      vim.notify = require('notify')
    end
  }

end)

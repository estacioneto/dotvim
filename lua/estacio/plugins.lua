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

  -- Writing code
  use 'jiangmiao/auto-pairs'
  use 'tpope/vim-surround'
  use 'chrisbra/vim-commentary'

  -- LSP
  use { 'neoclide/coc.nvim', branch = 'release' }
  use 'prettier/vim-prettier'

  -- Code tools
  -- See https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
  }
  use 'github/copilot.vim'

  -- Colorschemes
  use 'tomasiser/vim-code-dark'
  use 'marko-cerovac/material.nvim'
  use({ 'rose-pine/neovim', as = 'rose-pine' })
  -- Statusline
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  -- Debugging
  use 'mfussenegger/nvim-dap'
  use 'nvim-telescope/telescope-dap.nvim'
  use 'theHamsta/nvim-dap-virtual-text'
  use 'rcarriga/nvim-dap-ui'
end)

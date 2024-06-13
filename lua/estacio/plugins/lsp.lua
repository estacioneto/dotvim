return {
  -- LSP Zero: https://github.com/VonHeikemen/lsp-zero.nvim
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      --- Uncomment these if you want to manage LSP servers from neovim
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'L3MON4D3/LuaSnip' },
    },
  },

  {
    'folke/trouble.nvim',
    opts = {},
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
  },
  -- Formatting
  {
    -- https://github.com/mhartington/formatter.nvim
    'mhartington/formatter.nvim',
    lazy = false,
    keys = {
      { '<leader>fmt', '<cmd>Format<CR>', desc = 'Format' },
    },
    config = function()
      require('formatter').setup {
        logging = true,
        log_level = vim.log.levels.WARN,
        filetype = {
          lua = { require('formatter.filetypes.lua').stylua },

          typescript = { require('formatter.filetypes.typescript').prettier },
          javascript = { require('formatter.filetypes.javascript').prettier },
          typescriptreact = {
            require('formatter.filetypes.typescriptreact').prettier,
          },

          html = { require('formatter.filetypes.html').prettier },
          css = { require('formatter.filetypes.css').prettier },
          json = { require('formatter.filetypes.json').prettier },
        },
      }
    end,
  },
}

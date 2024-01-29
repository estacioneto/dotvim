return {
  -- LSP
  {
    'neoclide/coc.nvim',
    branch = 'release',
    build = 'yarn install --frozen-lockfile',
  },
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
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = { { '<leader>T', '<cmd>TroubleToggle<CR>', desc = 'Trouble' } },
  },
  {
    'github/copilot.vim',
    config = function()
      -- Also see: https://github.com/orgs/community/discussions/41869
      -- Options
      vim.g.copilot_enabled = true
      vim.g.copilot_node_command = '/usr/local/bin/node'
      vim.g.copilot_filetypes = {
        ['*'] = false,
        typescript = true,
        javascript = true,

        lua = true,
        markdown = true,

        erlang = true,
      }
    end,
  },

  -- Formatting
  {
    -- https://github.com/mhartington/formatter.nvim
    'mhartington/formatter.nvim',
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

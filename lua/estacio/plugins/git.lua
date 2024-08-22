return {
  {
    'tpope/vim-fugitive',
    keys = {
      { '<leader>gs', '<cmd>Git<CR>', desc = 'vim-fugitive', silent = true },
    },
    event = 'CmdlineEnter',
  },
  {
    'github/copilot.vim',
    config = function()
      -- Also see: https://github.com/orgs/community/discussions/41869
      -- Options
      vim.g.copilot_enabled = true
      vim.g.copilot_node_command = '/opt/homebrew/bin/node'
      vim.g.copilot_filetypes = {
        ['*'] = false,
        typescript = true,
        typescriptreact = true,
        javascript = true,
        css = true,

        lua = true,
        markdown = true,

        erlang = true,
      }
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        watch_gitdir = {
          enable = require('estacio.git').is_small_repo(),
        },
        current_line_blame = true,
      }
    end,
  },
  {
    'sindrets/diffview.nvim',
    keys = {
      { '<leader>dvo', '<cmd>DiffviewOpen<CR>', desc = '(diffview.nvim) Open', silent = true },
      { '<leader>dvc', '<cmd>DiffviewClose<CR>', desc = '(diffview.nvim) Close', silent = true },
    },
    cmd = { 'DiffviewOpen', 'DiffviewClose' },
    config = function()
      require('diffview').setup {
        enhanced_diff_hl = true
      }
    end
  }
}

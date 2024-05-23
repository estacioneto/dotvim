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
          enable = false,
        },
        current_line_blame = true,
      }
    end,
  },
}

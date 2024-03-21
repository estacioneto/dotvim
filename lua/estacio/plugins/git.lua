return {
  {
    'tpope/vim-fugitive',
    keys = {
      { '<leader>gs', '<cmd>Git<CR>', desc = 'vim-fugitive', silent = true },
    },
    event = 'CmdlineEnter',
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

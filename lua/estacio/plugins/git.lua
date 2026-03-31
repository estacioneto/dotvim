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
          enable = require('estacio.git').is_small_repo(),
        },
        current_line_blame = true,
      }
    end,
  },
  {
    'sindrets/diffview.nvim',
    keys = {
      {
        '<leader>dvo',
        '<cmd>DiffviewOpen<CR>',
        desc = '(diffview.nvim) Open',
        silent = true,
      },
      {
        '<leader>dvc',
        '<cmd>DiffviewClose<CR>',
        desc = '(diffview.nvim) Close',
        silent = true,
      },
    },
    cmd = { 'DiffviewOpen', 'DiffviewClose' },
    config = function()
      local actions = require 'diffview.actions'

      require('diffview').setup {
        enhanced_diff_hl = true,
        keymaps = {
          disable_defaults = false,
          view = {
            {
              'n',
              '<leader>cl',
              actions.conflict_choose 'ours',
              { desc = 'Choose the OURS (Left) version of a conflict' },
            },
            {
              'n',
              '<leader>cL',
              actions.conflict_choose_all 'ours',
              { desc = 'Choose ALL OURS (Left) version of a conflict' },
            },
            {
              'n',
              '<leader>cr',
              actions.conflict_choose 'theirs',
              { desc = 'Choose the THEIRS (Right) version of a conflict' },
            },
            {
              'n',
              '<leader>cR',
              actions.conflict_choose_all 'theirs',
              { desc = 'Choose ALL THEIRS (Right) version of a conflict' },
            },
          },
        },
      }
    end,
  },
}

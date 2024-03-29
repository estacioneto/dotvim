return {
  -- Finding everything
  -- See https://github.com/ibhagwan/fzf-lua
  {
    'ibhagwan/fzf-lua',
    lazy = false,
    -- optional for icon support
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- See https://www.reddit.com/r/neovim/comments/1bqf1w3/psa_fzflua_pulls_cause_an_error_my_github_account/
    url = 'https://gitlab.com/ibhagwan/fzf-lua'
  },
}

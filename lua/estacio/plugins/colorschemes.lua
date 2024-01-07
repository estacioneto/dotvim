return {
  -- Colorschemes
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    config = function()
      require('rose-pine').setup {
        styles = {
          italic = false,
        },
        highlight_groups = {
          Comment = { italic = true },
        },
      }
    end,
  },
  { 'catppuccin/nvim', name = 'catppuccin', lazy = true },
  { 'tomasiser/vim-code-dark', lazy = true },
  { 'marko-cerovac/material.nvim', lazy = true },
  { 'askfiy/killer-queen', lazy = true }
}

return {
  {
    'rcarriga/nvim-notify',
    dependencies = { { 'nvim-lua/plenary.nvim' } },
    config = function()
      vim.notify = require 'notify'
    end,
  },
}

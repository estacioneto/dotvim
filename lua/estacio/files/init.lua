vim.keymap.set('n', '<leader>sg', function()
  local pattern = vim.fn.input('Pattern: ', '')

  vim.cmd('silent! grep! '..pattern)
  vim.cmd[[copen]]
end)

-- fzf-lua FTW :)
local my_fzf = require('estacio.files.fzf')

my_fzf.set_mappings()
my_fzf.create_commands()

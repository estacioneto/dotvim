vim.keymap.set('n', '<leader>sg', function()
  local pattern = vim.fn.input('Pattern: ', '')

  vim.cmd('silent! grep! '..pattern)
  vim.cmd[[copen]]
end)

-- fzf-lua FTW :)
require('estacio.files.fzf').set_mappings()

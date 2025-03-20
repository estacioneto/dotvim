vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', '', {
  noremap = true,
  silent = true,
  callback = require('kulala').run,
  desc = 'Execute the request',
})

vim.api.nvim_buf_set_keymap(0, 'n', '[', '', {
  noremap = true,
  silent = true,
  callback = require('kulala').jump_prev,
  desc = 'Jump to the previous request',
})

vim.api.nvim_buf_set_keymap(0, 'n', ']', '', {
  noremap = true,
  silent = true,
  callback = require('kulala').jump_next,
  desc = 'Jump to the next request',
})

vim.api.nvim_buf_set_keymap(0, 'n', '<leader>i', '', {
  noremap = true,
  silent = true,
  callback = require('kulala').inspect,
  desc = 'Inspect the current request',
})

vim.api.nvim_buf_set_keymap(0, 'n', '<leader>t', '', {
  noremap = true,
  silent = true,
  callback = require('kulala').toggle_view,
  desc = 'Toggle between body and headers',
})

vim.api.nvim_buf_set_keymap(0, 'n', '<leader>co', '', {
  noremap = true,
  silent = true,
  callback = require('kulala').copy,
  desc = 'Copy the current request as a curl command',
})

vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ci', '', {
  noremap = true,
  silent = true,
  callback = require('kulala').from_curl,
  desc = 'Paste curl from clipboard as http request',
})

vim.api.nvim_buf_set_keymap(0, 'n', '<leader>f', '', {
  noremap = true,
  silent = true,
  callback = require('kulala').search,
  desc = 'Search for a request by name',
})

vim.api.nvim_buf_set_keymap(0, 'n', '<leader>es', '', {
  noremap = true,
  silent = true,
  callback = require('kulala').set_selected_env,
  desc = 'Select an environment',
})

vim.api.nvim_buf_set_keymap(0, 'n', '<leader>e?', '', {
  noremap = true,
  silent = true,
  callback = function()
    vim.notify(
      require('kulala').get_selected_env(),
      vim.log.levels.INFO,
      { title = '🐼 Current env' }
    )
  end,
  desc = 'Show the current environment',
})

vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ss', '', {
  noremap = true,
  silent = true,
  callback = require('kulala').show_stats,
  desc = 'Show request statistics',
})

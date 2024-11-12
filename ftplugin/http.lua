-- See https://github.com/mistweaverco/kulala.nvim/blob/main/lua/kulala/ui/init.lua#L18C1-L30C4
local get_kulala_win = function()
  local GLOBALS = require 'kulala.globals'

  -- Iterate through all windows in current tab
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local name = vim.api.nvim_buf_get_name(buf)
    -- Check if the name matches
    if name == GLOBALS.UI_ID then
      return win
    end
  end
  -- Return nil if no windows is found with the given buffer name
  return nil
end

vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', '', {
  noremap = true,
  silent = true,
  callback = function()
    local kulala = require 'kulala'
    -- Check if there is any kulala://ui buffer open
    local win = get_kulala_win()
    -- If no window is found, open a new one by toggling the view twice
    if not win then
      kulala.toggle_view()
      kulala.toggle_view()
    end

    -- Inspect the request before running it so we can always see the computed values
    kulala.inspect()
    kulala.run()

    -- Post the inspected request to the nvim messages
    local buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

    local timestamp = os.date('%Y-%m-%d %H:%M:%S')
    print('=== 🐼 Request at ' .. timestamp .. ' ===\n')

    for _, line in ipairs(lines) do
      print(line)
    end

    print('\n=== 🐼 Request end ===')
  end,
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

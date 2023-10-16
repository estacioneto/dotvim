-- Telescope
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>gd', builtin.find_files, {})
vim.keymap.set('n', '<leader>gr', builtin.git_files, {})

-- Find files inside directory
vim.keymap.set('n', '<leader>fd', function() builtin.find_files({ no_ignore = true }) end, {})
-- Find files inside repo
vim.keymap.set('n', '<leader>fr', function()
  builtin.find_files({
    no_ignore = true,
    cwd = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  })
end, {})

local function fuzzySearch(opts)
  opts = opts or {}

  builtin.grep_string({
    cwd = opts.cwd,
    path_display = { 'smart' },
    only_sort_text = true,
    word_match = "-w",
    search = '',
  })
end

vim.keymap.set('n', '<leader>sd', function() fuzzySearch() end, {})

vim.keymap.set('n', '<leader>sr', function()
  fuzzySearch({ cwd = vim.fn.systemlist('git rev-parse --show-toplevel')[1] })
end, {})
vim.keymap.set('n', '<leader>wg', builtin.grep_string, {})

vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

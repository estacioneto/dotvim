-- Telescope
require('telescope').setup{
  defaults = {
    file_ignore_patterns = {
      'node_modules'
    }
  }
}
local builtin = require('telescope.builtin')

local is_inside_work_tree = {}

local function project_files(opts)
  local cwd = vim.fn.getcwd()
  if is_inside_work_tree[cwd] == nil then
    vim.fn.system("git rev-parse --is-inside-work-tree")
    is_inside_work_tree[cwd] = vim.v.shell_error == 0
  end

  if is_inside_work_tree[cwd] then
    builtin.git_files(opts)
  else
    builtin.find_files(opts)
  end
end

vim.keymap.set('n', '<leader>gd', function() project_files({ use_git_root = false}) end)
vim.keymap.set('n', '<leader>gr', project_files)

-- Find files inside directory
vim.keymap.set('n', '<leader>fd', function() builtin.find_files({ no_ignore = true }) end)
-- Find files inside repo
vim.keymap.set('n', '<leader>fr', function()
  builtin.find_files({
    no_ignore = true,
    cwd = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  })
end)

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

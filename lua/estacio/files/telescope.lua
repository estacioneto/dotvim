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

vim.keymap.set('n', '<leader>gd', function() project_files({ use_git_root = false, hidden = true }) end)
vim.keymap.set('n', '<leader>gr', function() project_files({ hidden = true }) end)

-- Find files inside directory
vim.keymap.set('n', '<leader>fd', function() builtin.find_files({ no_ignore = true, hidden = true }) end)

-- Too slow for search :(
-- I wish I could use it, but it's just too slow
--
-- Find files inside repo
-- vim.keymap.set('n', '<leader>fr', function()
  -- builtin.find_files({
    -- no_ignore = true,
    -- hidden = true,
    -- cwd = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
    -- })
    -- end)
    --
    -- local function fuzzySearch(opts)
      -- opts = opts or {}

      -- builtin.grep_string({
        -- cwd = opts.cwd,
        -- path_display = { 'smart' },
        -- only_sort_text = true,
        -- word_match = "-w",
        -- search = '',
        -- })
        -- end

        -- vim.keymap.set('n', '<leader>sd', fuzzySearch)

        -- vim.keymap.set('n', '<leader>sr', function()
          -- fuzzySearch({ cwd = vim.fn.systemlist('git rev-parse --show-toplevel')[1] })
          -- end)

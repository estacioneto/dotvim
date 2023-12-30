local fzf = require('fzf-lua')

-- Might be useful for small git repositories but for large ones it can delay
-- the whole process of finding.
--
-- See: https://github.com/ibhagwan/fzf-lua/issues/126
local git_icons = false

local function get_git_root ()
  return vim.fn.system({ 'git', 'rev-parse', '--show-toplevel' }):gsub('\n', '')
end

local M = {}

-- https://github.com/ibhagwan/fzf-lua/issues/860
M.files_picker = function(opts)
  opts = opts or {}

  opts.actions = {
    -- Use ctrl-g to toggle --no-ignore
    ['ctrl-g'] = function()
      opts.resume = true
      M.files_picker(opts)
    end,
  }

  opts.cmd = opts.cmd or 'rg --color=never --files --hidden --follow --no-ignore'

  if opts.cmd:match '%s+%-%-no%-ignore$' then
    opts.cmd = opts.cmd:gsub('%s+%-%-no%-ignore$', '')
  else
    opts.cmd = opts.cmd .. ' --no-ignore'
  end

  fzf.files(opts)
end

local EXCLUDED_DIRS = table.concat(vim.tbl_map(function (dir)
  return '-path "*/'..dir..'*"'
end, {
  'Library',
  'Pictures',
  '.Trash',
  'node_modules',
  'vendor',
}), ' -o ')

local function reload_config()
  -- Source init.lua
  vim.cmd('so ~/.config/nvim/init.lua')

  -- Source all lua files in plugin directory
  for _, file in ipairs(vim.fn.glob('~/.config/nvim/plugin/**/*.lua', 0, 1)) do
    vim.cmd('so ' .. file)
  end

  -- Source all lua files in after directory
  for _, file in ipairs(vim.fn.glob('~/.config/nvim/after/**/*.lua', 0, 1)) do
    vim.cmd('so ' .. file)
  end
end


-- Get all repositories
function M.repos_picker(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.fn.expand('~')

  opts.cmd = table.concat({
    'find',
    opts.cwd,
    '-type d',
    '\\(',
    EXCLUDED_DIRS,
    '\\)',
    '-prune',
    '-o',
    '-name ".git"',
    '-maxdepth 4',
    '-exec dirname {} \\;'
  }, ' ')

  fzf.fzf_exec(opts.cmd, { fn_selected = function (selected)
    if selected[1] ~= '' then
      return
    end

    vim.cmd('cd '..selected[2])

    reload_config()

    M.subdir_picker()
  end })
end

function M.subdir_picker(opts, fallback)
  opts = opts or {}
  opts.cwd = opts.cwd or '.'

  opts.cmd = table.concat({
    'find',
    opts.cwd,
    '\\(',
    EXCLUDED_DIRS,
    '-o -path "*/.git*"',
    '\\)',
    '-prune',
    '-o',
    '-type d',
    '-print',
    '-maxdepth 5',
  }, ' ')

  fzf.fzf_exec(opts.cmd, { fn_selected = function (selected)
    if selected[1] ~= '' then
      if fallback then
        fallback(opts)
      end

      return
    end

    vim.cmd('cd '..selected[2])

    reload_config()

    M.files_picker({ git_icons = git_icons })
  end })
end

function M.nodejs_packages_picker(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or '.'

  opts.cmd = table.concat({
    'find',
    opts.cwd,
    '-type d',
    '\\(',
    EXCLUDED_DIRS,
    '-o -path "*/.git*"',
    '\\)',
    '-prune',
    '-o',
    '-name "package.json"',
    '-exec dirname {} \\;'
  }, ' ')

  fzf.fzf_exec(opts.cmd, { fn_selected = function (selected)
    if selected[1] ~= '' then
      return
    end

    vim.cmd('cd '..selected[2])

    reload_config()

    M.files_picker({ git_icons = git_icons })
  end })
end

function M.parent_dirs_picker(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.fn.getcwd()

  local parent_directories = {}
  local cwd = opts.cwd

  while cwd ~= "/" do
      table.insert(parent_directories, cwd)
      cwd = vim.fn.fnamemodify(cwd, ':h')
  end

  fzf.fzf_exec(parent_directories, { fn_selected = function (selected)
    if selected[1] ~= '' then
      return
    end

    vim.cmd('cd '..selected[2])

    reload_config()

    M.subdir_picker(
      { git_icons = git_icons },
      -- Fallback
      function () M.files_picker({ git_icons = git_icons }) end
    )
  end })
end

-- Set mappings
-- Current directory
vim.keymap.set('n', '<leader>gd', function ()
  fzf.git_files({ cwd = vim.fn.getcwd(), git_icons = git_icons })
end)
vim.keymap.set('n', '<leader>fd', function () M.files_picker({ git_icons = git_icons }) end)

vim.keymap.set('n', '<leader>sd', function () fzf.grep_project({ git_icons = git_icons }) end)
vim.keymap.set('v', '<leader>sd', function () fzf.grep_visual({ git_icons = git_icons }) end)

-- Git root
vim.keymap.set('n', '<leader>gr', function ()
  fzf.git_files({
    cwd = get_git_root(),
    git_icons = git_icons
  })
end)
vim.keymap.set('n', '<leader>fr', function ()
  M.files_picker({
    cwd = get_git_root(),
    git_icons = git_icons
  })
end)
vim.keymap.set('n', '<leader>sr', function()
  fzf.grep_project({
    cwd = get_git_root(),
    git_icons = git_icons
  })
end)
vim.keymap.set('v', '<leader>sr', function()
  fzf.grep_visual({
    cwd = get_git_root(),
    git_icons = git_icons
  })
end)

-- Resuming last action
vim.keymap.set('n', '<leader>ff', fzf.resume)

-- History
vim.keymap.set('n', '<leader>fo', fzf.oldfiles)

-- Buffers
vim.keymap.set('n', '<leader>fb', fzf.buffers)

-- Custom functions
vim.keymap.set('n', '<leader>cdr', M.repos_picker)
vim.keymap.set('n', '<leader>cds', M.subdir_picker)
vim.keymap.set('n', '<leader>cdp', M.parent_dirs_picker)
vim.keymap.set('n', '<leader>cds', M.nodejs_packages_picker)

-- Create commands
vim.api.nvim_create_user_command('ReposPicker', M.repos_picker, {})
vim.api.nvim_create_user_command('SubdirPicker', M.subdir_picker, {})
vim.api.nvim_create_user_command('NodejsPicker', M.nodejs_packages_picker, {})
vim.api.nvim_create_user_command('ParentDirsPicker', M.parent_dirs_picker, {})

return M

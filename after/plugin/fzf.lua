local fzf = require('fzf-lua')
local git = require('estacio.git')

fzf.setup {
  previewers = {
    builtin = {
      syntax_limit_b = 0
    }
  }
}

-- Might be useful for small git repositories but for large ones it can delay
-- the whole process of finding.
--
-- See: https://github.com/ibhagwan/fzf-lua/issues/126
local git_icons = git.is_small_repo()

local M = {}

-- https://github.com/ibhagwan/fzf-lua/issues/860
M.files_picker = function(opts)
  opts = opts or {}

  opts.actions = {
    -- Use ctrl-g to toggle --no-ignore
    ['ctrl-g'] = fzf.actions.toggle_ignore,
  }

  fzf.files(opts)
end

local EXCLUDED_DIRS_FD = table.concat(vim.tbl_map(function (dir)
  return '--exclude '..dir
end, {
  'Library',
  'Pictures',
  '.Trash',
  'node_modules',
  'vendor',
}), ' ')

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

  git_icons = git.is_small_repo()
end

function M.fd(opts, callback, fallback)
  opts = opts or {}
  opts.cwd = opts.cwd or '.'
  opts.prompt = opts.prompt or 'Directories > '

  opts.cmd = opts.cmd or table.concat({
    'fd',
    '-t d',
    '-d 5',
    '--no-ignore',
    '-H',
    '--base-directory '..opts.cwd,
    EXCLUDED_DIRS_FD,
    '--exclude .git',
  }, ' ')

  opts.actions = {
    ['default'] = {
      function (selected)
        if selected[1] == nil then
          return
        end

        vim.cmd('cd '..vim.fn.expand(opts.cwd..'/'..selected[1]))

        reload_config()
        callback(opts)
      end,
    },
    ['esc'] = function ()
      if fallback then
        fallback(opts)
      end
    end
  }

  fzf.fzf_exec(opts.cmd, opts)
end


-- Get all repositories
function M.repos_picker(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.fn.expand('~')
  opts.prompt = opts.prompt or 'Git repos > '

  opts.cmd = table.concat({
    'fd',
    '-t d',
    EXCLUDED_DIRS_FD,
    '--no-ignore',
    '-H',
    '--base-directory '..opts.cwd,
    '^.git$',
    '-x dirname {} \\;'
  }, ' ')

  local function callback ()
    M.subdir_picker(
      { git_icons = git_icons },
      -- Fallback
      function () M.files_picker({ git_icons = git_icons }) end
    )
  end

  M.fd(opts, callback)
end

function M.subdir_picker(opts, fallback)
  opts = opts or {}
  local function callback ()
    M.files_picker({ git_icons = git_icons })
  end

  M.fd(opts, callback, fallback)
end

function M.nodejs_packages_picker(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or '.'

  opts.cmd = table.concat({
    'fd',
    '-t f',
    '--no-ignore',
    '-H',
    '--base-directory '..opts.cwd,
    EXCLUDED_DIRS_FD,
    '--exclude .git',
    '^package.json$',
    '-x dirname {} \\;'
  }, ' ')

  local function callback ()
    M.files_picker({ git_icons = git_icons })
  end

  M.fd(opts, callback)
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

  opts.actions = {
    ['default'] = function (selected)
      -- Full path so it doesn't need to be expanded
      vim.cmd('cd '..selected[1])

      reload_config()

      M.subdir_picker(
        { git_icons = git_icons },
        -- Fallback
        function () M.files_picker({ git_icons = git_icons }) end
      )
    end
  }

  fzf.fzf_exec(parent_directories, opts)
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
    cwd = git.get_git_root(),
    git_icons = git_icons
  })
end)
vim.keymap.set('n', '<leader>fr', function ()
  M.files_picker({
    cwd = git.get_git_root(),
    git_icons = git_icons
  })
end)
vim.keymap.set('n', '<leader>sr', function()
  fzf.grep_project({
    cwd = git.get_git_root(),
    git_icons = git_icons
  })
end)
vim.keymap.set('v', '<leader>sr', function()
  fzf.grep_visual({
    cwd = git.get_git_root(),
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
vim.keymap.set('n', '<leader>cdn', M.nodejs_packages_picker)

-- Create commands
vim.api.nvim_create_user_command('ReposPicker', M.repos_picker, {})
vim.api.nvim_create_user_command('SubdirPicker', M.subdir_picker, {})
vim.api.nvim_create_user_command('NodejsPicker', M.nodejs_packages_picker, {})
vim.api.nvim_create_user_command('ParentDirsPicker', M.parent_dirs_picker, {})

return M

local fzf = require 'fzf-lua'

local git = require 'estacio.git'
local fzf_directories = require 'estacio.fzf.directories'
local fzf_notifications = require 'estacio.fzf.notifications'

local M = {}

local function setup_commands()
  vim.api.nvim_create_user_command(
    'ReposPicker',
    fzf_directories.repos_picker,
    {}
  )
  vim.api.nvim_create_user_command(
    'SubdirPicker',
    fzf_directories.subdir_picker,
    {}
  )
  vim.api.nvim_create_user_command(
    'NodejsPicker',
    fzf_directories.nodejs_packages_picker,
    {}
  )
  vim.api.nvim_create_user_command(
    'ParentDirsPicker',
    fzf_directories.parent_dirs_picker,
    {}
  )

  vim.api.nvim_create_user_command(
    'NotificationsPicker',
    fzf_notifications.notifications_picker,
    {}
  )
end

local function set_keymaps()
  -- Set mappings
  -- Current directory
  vim.keymap.set('n', '<leader>gd', function()
    fzf.git_files { cwd = vim.fn.getcwd() }
  end)
  vim.keymap.set('n', '<leader>fd', fzf.files)

  vim.keymap.set('n', '<leader>sd', fzf.grep_project)
  -- Adds no-ignore flag to rg command
  vim.keymap.set('n', '<leader>sid', function()
    fzf.grep_project {
      rg_opts = '--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --no-ignore -e',
    }
  end)

  vim.keymap.set('v', '<leader>sd', fzf.grep_visual)

  -- Git root
  vim.keymap.set('n', '<leader>gr', function()
    fzf.git_files {
      cwd = git.get_git_root(),
    }
  end)
  vim.keymap.set('n', '<leader>fr', function()
    fzf.files {
      cwd = git.get_git_root(),
    }
  end)
  vim.keymap.set('n', '<leader>sr', function()
    fzf.grep_project {
      cwd = git.get_git_root(),
    }
  end)
  -- Adds no-ignore flag to rg command
  vim.keymap.set('n', '<leader>sir', function()
    fzf.grep_project {
      cwd = git.get_git_root(),
      rg_opts = '--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --no-ignore -e',
    }
  end)

  vim.keymap.set('v', '<leader>sr', function()
    fzf.grep_visual {
      cwd = git.get_git_root(),
    }
  end)

  -- Resuming last action
  vim.keymap.set('n', '<leader>ff', fzf.resume)

  -- History
  vim.keymap.set('n', '<leader>fo', fzf.oldfiles)

  -- Buffers
  vim.keymap.set('n', '<leader>fb', fzf.buffers)

  -- Quickfix
  vim.keymap.set('n', '<leader>fql', fzf.quickfix)
  vim.keymap.set('n', '<leader>fqs', fzf.quickfix_stack)

  -- Custom functions
  vim.keymap.set(
    'n',
    '<leader>cdr',
    fzf_directories.repos_picker,
    { desc = 'Repos' }
  )
  vim.keymap.set(
    'n',
    '<leader>cds',
    fzf_directories.subdir_picker,
    { desc = 'Subdir' }
  )
  vim.keymap.set(
    'n',
    '<leader>cdp',
    fzf_directories.parent_dirs_picker,
    { desc = 'Parent dirs' }
  )
  vim.keymap.set(
    'n',
    '<leader>cdn',
    fzf_directories.nodejs_packages_picker,
    { desc = 'Nodejs packages' }
  )

  vim.keymap.set(
    'n',
    '<leader>fn',
    fzf_notifications.notifications_picker,
    { desc = 'Notifications' }
  )
end

local function reload_config()
  -- Source init.lua
  vim.cmd 'so ~/.config/nvim/init.lua'

  -- Source all lua files in plugin directory
  for _, file in ipairs(vim.fn.glob('~/.config/nvim/plugin/**/*.lua', 0, 1)) do
    vim.cmd('so ' .. file)
  end

  -- Source all lua files in after directory
  for _, file in ipairs(vim.fn.glob('~/.config/nvim/after/**/*.lua', 0, 1)) do
    vim.cmd('so ' .. file)
  end

  M.setup()
end

function M.setup()
  -- Might be useful for small git repositories but for large ones it can delay
  -- the whole process of finding.
  --
  -- See: https://github.com/ibhagwan/fzf-lua/issues/126
  local git_icons = git.is_small_repo()

  fzf.setup {
    defaults = {
      git_icons = git_icons,
    },
    winopts = {
      preview = {
        layout = 'vertical',
        vertical = 'down:60%',
      },
    },
    previewers = {
      builtin = {
        syntax_limit_b = 0,
      },
    },
    keymap = {
      builtin = {
        ['<c-1>'] = 'toggle-help',
        ['<c-f>'] = 'toggle-fullscreen',
        ['<c-D>'] = 'preview-page-down',
        ['<c-U>'] = 'preview-page-up',
      },
      fzf = {
        ['ctrl-z'] = 'abort',
        -- Useful when sending to quickfix list ('alt-q')
        ['ctrl-a'] = 'toggle-all',
        ['alt-a'] = 'toggle-all',
        ['ctrl-d'] = 'half-page-down',
        ['ctrl-u'] = 'half-page-up',
      },
    },
  }

  fzf_directories.setup { reload_config = reload_config }

  setup_commands()
  set_keymaps()
end

return M

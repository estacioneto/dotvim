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
  end, { desc = '[FzfLua] Git files' })
  vim.keymap.set('n', '<leader>fd', fzf.files, { desc = '[FzfLua] Files' })

  vim.keymap.set('n', '<leader>sd', fzf.grep_project, { desc = '[FzfLua] Grep' })

  vim.keymap.set('v', '<leader>sd', fzf.grep_visual, { desc = '[FzfLua] Grep visual' })

  -- Git root
  vim.keymap.set('n', '<leader>gr', function()
    fzf.git_files {
      cwd = git.get_git_root(),
    }
  end, { desc = '[FzfLua] Repo git files' })
  vim.keymap.set('n', '<leader>fr', function()
    fzf.files {
      cwd = git.get_git_root(),
    }
  end, { desc = '[FzfLua] Repo files' })
  vim.keymap.set('n', '<leader>sr', function()
    fzf.grep_project {
      cwd = git.get_git_root(),
    }
  end, { desc = '[FzfLua] Repo grep' })

  vim.keymap.set('v', '<leader>sr', function()
    fzf.grep_visual {
      cwd = git.get_git_root(),
    }
  end, { desc = '[FzfLua] Repo grep visual' })

  -- Resuming last action
  vim.keymap.set('n', '<leader>ff', fzf.resume, { desc = '[FzfLua] Resume last search' })

  -- History
  vim.keymap.set('n', '<leader>fo', fzf.oldfiles, { desc = '[FzfLua] Oldfiles' })

  -- Buffers
  vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = '[FzfLua] Buffers' })

  -- Quickfix
  vim.keymap.set('n', '<leader>fql', fzf.quickfix, { desc = '[FzfLua] Quickfix list' })
  vim.keymap.set('n', '<leader>fqs', fzf.quickfix_stack, { desc = '[FzfLua] Quickfix stack' })

  -- Commands
  vim.keymap.set('n', '<leader>fc', fzf.commands, { desc = '[FzfLua] Commands' })

  -- Git
  vim.keymap.set('n', '<leader>fgc', fzf.git_commits, { desc = '[FzfLua] Git commits' })
  vim.keymap.set('n', '<leader>fgb', fzf.git_commits, { desc = '[FzfLua] Git buffer commits' })

  -- Custom functions
  vim.keymap.set(
    'n',
    '<leader>cdr',
    fzf_directories.repos_picker,
    { desc = '[FzfLua][Custom] Repos' }
  )
  vim.keymap.set(
    'n',
    '<leader>cds',
    fzf_directories.subdir_picker,
    { desc = '[FzfLua][Custom] Subdir' }
  )
  vim.keymap.set(
    'n',
    '<leader>cdp',
    fzf_directories.parent_dirs_picker,
    { desc = '[FzfLua][Custom] Parent dirs' }
  )
  vim.keymap.set(
    'n',
    '<leader>cdn',
    fzf_directories.nodejs_packages_picker,
    { desc = '[FzfLua][Custom] Nodejs packages' }
  )

  vim.keymap.set(
    'n',
    '<leader>fn',
    fzf_notifications.notifications_picker,
    { desc = '[FzfLua][Custom] Notifications' }
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
    grep = {
      -- Use `ctrl-i` to not override the `ctrl-g` regex toggle
      -- See https://github.com/ibhagwan/fzf-lua/issues/1018
      actions = {
        ['ctrl-i'] = { fzf.actions.toggle_ignore },
        ['ctrl-q'] = fzf.actions.file_sel_to_qf,
      },
    },
    files = {
      actions = {
        ['ctrl-q'] = fzf.actions.file_sel_to_qf,
      },
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
        ['ctrl-a'] = 'toggle-all',
        ['alt-a'] = 'toggle-all',
        ['ctrl-d'] = 'half-page-down',
        ['ctrl-u'] = 'half-page-up',
      },
    },
  }

  fzf_directories.setup { reload_config = reload_config }
  fzf.register_ui_select()

  setup_commands()
  set_keymaps()
end

return M

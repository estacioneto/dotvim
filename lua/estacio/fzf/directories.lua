local fzf = require 'fzf-lua'

local M = {}

local EXCLUDED_DIRS_FD = table.concat(
  vim.tbl_map(function(dir)
    return '--exclude ' .. dir
  end, {
    'Library',
    'Pictures',
    '.Trash',
    'node_modules',
    'vendor',
  }),
  ' '
)

function M.fd(opts, callback, fallback)
  opts = opts or {}
  opts.cwd = opts.cwd or '.'
  opts.prompt = opts.prompt or 'Directories > '

  opts.cmd = opts.cmd
    or table.concat({
      'fd',
      '-t d',
      '-d 5',
      '--no-ignore',
      '-H',
      '--base-directory ' .. opts.cwd,
      EXCLUDED_DIRS_FD,
      '--exclude .git',
    }, ' ')

  opts.actions = {
    ['default'] = function(selected)
      if selected[1] == nil then
        return
      end

      vim.cmd('cd ' .. vim.fn.expand(opts.cwd .. '/' .. selected[1]))

      M._reload_config()
      callback(opts)
    end,
    ['esc'] = function()
      if fallback then
        fallback(opts)
      end
    end,
  }

  fzf.fzf_exec(opts.cmd, opts)
end

-- Get all repositories
function M.repos_picker(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.fn.expand '~'
  opts.prompt = opts.prompt or 'Git repos > '

  opts.cmd = table.concat({
    'fd',
    '-t d',
    EXCLUDED_DIRS_FD,
    '--no-ignore',
    '-H',
    '--base-directory ' .. opts.cwd,
    '^.git$',
    '-x dirname {} \\;',
  }, ' ')

  local function callback()
    M.subdir_picker(
      {},
      -- Fallback
      function()
        fzf.files()
      end
    )
  end

  M.fd(opts, callback)
end

function M.subdir_picker(opts, fallback)
  opts = opts or {}
  local function callback()
    fzf.files()
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
    '--base-directory ' .. opts.cwd,
    EXCLUDED_DIRS_FD,
    '--exclude .git',
    '^package.json$',
    '-x dirname {} \\;',
  }, ' ')

  local function callback()
    fzf.files()
  end

  M.fd(opts, callback)
end

function M.parent_dirs_picker(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.fn.getcwd()

  local parent_directories = {}
  local cwd = opts.cwd

  while cwd ~= '/' do
    table.insert(parent_directories, cwd)
    cwd = vim.fn.fnamemodify(cwd, ':h')
  end

  opts.actions = {
    ['default'] = function(selected)
      -- Full path so it doesn't need to be expanded
      vim.cmd('cd ' .. selected[1])

      M._reload_config()

      M.subdir_picker(
        {},
        -- Fallback
        function()
          fzf.files()
        end
      )
    end,
  }

  fzf.fzf_exec(parent_directories, opts)
end

function M.setup(opts)
  M._reload_config = opts.reload_config
end

return M

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

M.set_mappings = function ()
  -- Current directory
  vim.keymap.set('n', '<leader>gd', function ()
    fzf.git_files({ cwd = vim.fn.getcwd(), git_icons = git_icons })
  end)
  vim.keymap.set('n', '<leader>fd', function () M.files_picker({ git_icons = git_icons }) end)
  vim.keymap.set('n', '<leader>sd', function () fzf.grep_project({ git_icons = git_icons }) end)

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

  -- Resuming last action
  vim.keymap.set('n', '<leader>ff', fzf.resume)

  -- History
  vim.keymap.set('n', '<leader>fo', fzf.oldfiles)
end

return M

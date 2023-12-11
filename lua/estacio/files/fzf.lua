local fzf = require('fzf-lua')

local M = {}

-- https://github.com/ibhagwan/fzf-lua/issues/860
M.files_picker = function(opts)
    opts = opts or {}
    opts.cwd = opts.cwd or opts.repo and vim.fn.systemlist('git rev-parse --show-toplevel')[1]

    opts.cmd = opts.cmd or 'rg --color=never --files --hidden --follow'

    opts.actions = {
        -- Use ctrl-g to respect ignore
        ['ctrl-g'] = function(_, o)
          o.resume = true
          M.files_picker(o)
        end,
    }

    if opts.cmd:match '%s+%-%-no%-ignore$' then
        opts.cmd = opts.cmd:gsub('%s+%-%-no%-ignore$', '')
    else
        opts.cmd = opts.cmd .. ' --no-ignore'
    end

    fzf.files(opts)
end

M.set_mappings = function ()
  vim.keymap.set('n', '<leader>gd', fzf.git_files)
  vim.keymap.set('n', '<leader>fd', M.files_picker)

  vim.keymap.set('n', '<leader>gr', function() fzf.git_files({
    cwd = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  }) end)
  vim.keymap.set('n', '<leader>fr', function ()
    M.files_picker({ repo = true })
  end)

  vim.keymap.set('n', '<leader>ff', fzf.resume)

  vim.keymap.set('n', '<leader>sd', fzf.grep_project)
  vim.keymap.set('n', '<leader>sr', function() fzf.grep_project({
    cwd = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  }) end)
end

return M

local utils = require('estacio.utils')

local M = {}

function M.get_git_root()
  local handle = io.popen('git rev-parse --show-toplevel')
  if handle == nil then
    return ''
  end

  local result = handle:read('*a')
  handle:close()

  return result
end

-- Stash URL
local function get_file()
  -- get the relative file path
  local git_root_dir = M.get_git_root():match('^.*/')
  local file_path = vim.fn.expand('%:p')
  local relative_file_path = file_path:sub(#git_root_dir+1)

  -- Remove the first folder from the relative file path
  local pos = relative_file_path:find('/')

  if pos then
    relative_file_path = relative_file_path:sub(pos+1)
  end

  return relative_file_path
end

local function get_remote()
  -- get the remote url
  local handle = io.popen('git config --get remote.origin.url')
  if handle == nil then
    return ''
  end
  local result = handle:read('*a')

  if result == '' then
    print('No remote found')
    return ''
  end

  handle:close()
  local _, _, domain, _, group, repo = result:match('(ssh://)([^@]+)@([^:]+):(%d+)/([^/]+)/([^/]+).git')

  return ('https://%s/projects/%s/repos/%s/browse/'):format(domain, group:upper(), repo)
end

local function copy_file_remote_url()
  local fp = get_file()
  local rp = get_remote()
  local path = rp .. fp

  -- Copy URL to clipboard
  vim.fn.setreg('+', path)

  print('Copied to clipboard: ' .. path)
end

function M.is_small_repo()
  if M.get_git_root() == '' then
    return
  end
  -- If we're inside a Git repository, check the size-pack
  local handle = io.popen('git count-objects -v')
  if handle == nil then
    return
  end

  local result = handle:read('*a')
  handle:close()

  for line in result:gmatch('[^\r\n]+') do
    if line:find('size%-pack:') then
      local size_pack = tonumber(line:match('%d+'))
      if size_pack then
        -- Convert KB to MB and check if it's less than 500MB
        return (size_pack / 1024) < 500
      end
    end
  end

  -- Return false if size-pack is not found or not less than 500MB
  return false
end

local function stash_all()
  -- Check if Dispatch command is available
  utils.run_async_cmd('git', { 'stash', '--include-untracked' })
end

local function get_current_branch()
  local handle = io.popen('git rev-parse --abbrev-ref HEAD')
  if handle == nil then
    return
  end

  local result = handle:read('*a')
  handle:close()

  return result:gsub('\n', '')
end

local function git_update_branch(opts)
  local branch = opts.args
  local current_branch = get_current_branch()

  utils.run_async_cmd('git', { 'checkout', branch }, function (checkout_code)
    if checkout_code ~= 0 then
      return
    end

    utils.run_async_cmd('git', { 'pull', 'origin', branch, '-pr' }, function (pull_code)
      if pull_code ~= 0 then
        return
      end

      utils.run_async_cmd('git', { 'checkout', current_branch })
    end)
  end)
end

local function git_rebase(opts)
  local branch = opts.args
  utils.run_async_cmd('git', { 'rebase', branch, '--no-verify' })
end


M.set_commands = function()
  vim.api.nvim_create_user_command('GitRepoUrl', copy_file_remote_url, { nargs = 0 })
  vim.api.nvim_create_user_command('GitStashAll', stash_all, { nargs = 0 })
  vim.api.nvim_create_user_command('GitUpdate', git_update_branch, { nargs = 1 })
  vim.api.nvim_create_user_command('GitRebase', git_rebase, { nargs = 1 })
end

function M.set_keymaps()
  -- Keymap: Copy stash url to clipboard
  vim.keymap.set('n', '<leader>rurl', 'GitRepoUrl')
end


return M

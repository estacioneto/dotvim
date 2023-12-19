local autocmd_id = nil

local function MakeWatch()
  if autocmd_id ~= nil then
    return
  end

  local extension = vim.api.nvim_buf_get_name(0):match('^.+(%..+)$')

  autocmd_id = vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
    pattern = { '*'..extension },
    callback = function ()
      -- https://github.com/tpope/vim-dispatch/commit/7f164471d00688baf72979d9e1bfeaa0de21a4af
      vim.cmd.AbortDispatch()
      vim.cmd.Make()
    end
  })

  vim.cmd.Make()
end

local function MakeUnwatch()
  if autocmd_id == nil then
    return
  end

  vim.api.nvim_del_autocmd(autocmd_id)

  autocmd_id = nil
end

vim.api.nvim_create_user_command('MakeWatch', MakeWatch, {})
vim.api.nvim_create_user_command('MakeUnwatch', MakeUnwatch, {})

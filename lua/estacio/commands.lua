vim.api.nvim_create_user_command('WA', 'wa', {})
vim.api.nvim_create_user_command('Wa', 'wa', {})
vim.api.nvim_create_user_command('WQ', 'wq', {})
vim.api.nvim_create_user_command('Wq', 'wq', {})
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Q', 'q', {})

local fugitive_prefix = 'fugitive://'

vim.api.nvim_create_user_command('OpenImage', function()
  local file = vim.fn.expand('%')
  -- Open image of old commit
  if string.find(file, fugitive_prefix) then
    -- Creates a new file under the /tmp directory since the file doesn't exist
    file = '/tmp'..string.sub(file, #fugitive_prefix + 1, #file)
    if not vim.fn.filereadable(file) then
      vim.cmd('w ++p '..file)
    end
  end

  os.execute('open '..file)
end, { nargs = 0 })


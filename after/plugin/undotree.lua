if vim.fn.has("persistent_undo") then
  local target_path = vim.fn.expand('~/.undodir')

  -- create the directory and any parent directories
  -- if the location does not exist.
  if vim.fn.isdirectory(target_path) == 0 then
    vim.fn.mkdir(target_path, "p", 0700)
  end

  vim.opt.undodir = target_path
  vim.opt.undofile = true
end

-- Mappings
vim.keymap.set('n', '<leader>ut', vim.cmd.UndotreeToggle, { silent = true })


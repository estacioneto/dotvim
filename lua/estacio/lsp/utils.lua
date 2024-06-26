local M = {}

function M.rename_file()
  local source_file = vim.api.nvim_buf_get_name(0)

  local target_file
  vim.ui.input({
    prompt = 'Target: ',
    completion = 'file',
    default = source_file,
  }, function(input)
    target_file = input
  end)

  if not target_file or target_file == '' then
    vim.print 'Rename canceled!'
    return
  end

  local dir = target_file:match '.*/'
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, 'p')
  end

  vim.lsp.util.rename(source_file, target_file)

  return {
    source_file = source_file,
    target_file = target_file,
  }
end

return M

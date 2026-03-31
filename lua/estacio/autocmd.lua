local function check_terminal_and_disable_number()
  if vim.bo.buftype == 'terminal' then
    vim.wo.number = false

    vim.wo.relativenumber = false
  end
end

local filetype_options = vim.api.nvim_create_augroup('FTOptions', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  group = filetype_options,
  pattern = 'gitcommit',
  callback = function()
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = filetype_options,
  pattern = 'nginx',
  callback = function()
    vim.bo.indentexpr = ''

    vim.bo.cindent = true

    vim.opt_local.cinkeys:remove '0#'
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = filetype_options,
  pattern = 'cs',
  callback = function()
    vim.bo.shiftwidth = 4

    vim.bo.softtabstop = 4
  end,
})

local terminal_group = vim.api.nvim_create_augroup('Term', { clear = true })

for _, event in ipairs { 'TermOpen', 'WinLeave', 'WinEnter', 'BufEnter', 'BufLeave' } do
  vim.api.nvim_create_autocmd(event, {
    group = terminal_group,
    callback = check_terminal_and_disable_number,
  })
end

-- Auto-create parent directories (except for URIs "://")
vim.api.nvim_create_autocmd({ 'BufWritePre', 'FileWritePre' }, {
  callback = function()
    local filename = vim.fn.expand '<afile>'

    if filename:find '://' then
      return
    end

    local directory = vim.fn.fnamemodify(filename, ':p:h')

    vim.fn.mkdir(directory, 'p')
  end,
})

-- Open image file
vim.api.nvim_create_autocmd({ 'BufReadPre', 'FileReadPre' }, {
  pattern = { '*.png', '*.jpeg', '*.jpg' },
  command = 'OpenImage',
})

-- See https://github.com/neovim/neovim/issues/20784#issuecomment-1288085253
-- Maybe later it would be worth using: https://github.com/antosha417/nvim-lsp-file-operations
local function rename_file()
  local source_file, target_file

  vim.ui.input({
    prompt = "Source: ",
    completion = "file",
    default = vim.api.nvim_buf_get_name(0)
  },
  function(input)
    source_file = input
  end)

  if not source_file or source_file == '' then
    vim.print('Rename canceled!')
    return
  end

  vim.ui.input({
    prompt = "Target: ",
    completion = "file",
    default = source_file
  },
  function(input)
    target_file = input
  end)

  if not target_file or target_file == '' then
    vim.print('Rename canceled!')
    return
  end

  local dir = target_file:match('.*/')
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end

  vim.lsp.util.rename(source_file, target_file)

  vim.lsp.buf.execute_command({
    command = "_typescript.applyRenameFile",
    arguments = {
      {
        sourceUri = source_file,
        targetUri = target_file,
      },
    },
    title = ""
  })
end

-- TODO: Add command to watch file save and re-run the :make
-- Also, do it on background instead
vim.cmd[[
augroup tsc\_comp

autocmd FileType typescript,typescriptreact compiler tsc | setlocal makeprg=tsc\ --noEmit\ --pretty\ false

augroup END
]]


return {
  filetypes = { 'typescript', 'typescriptreact', 'typescript.tsx', 'javascript' },
  handlers = {
    ['$/typescriptVersion'] = function(err, result)
      if err ~= nil then
        return
      end

      vim.g.lualine_ts_version = 'TSC: '..result.version
    end
  },
  settings = {
    typescript = {
      npm = 'yarn',
    }
  },
  init_options = {
    hostInfo = "neovim",
    maxTsServerMemory = 9216,
    preferences = {
      quotePreference = 'single',
      importModuleSpecifierPreference = 'relative',
    }
  },
  commands = {
    RenameFile = {
      rename_file,
      description = "Rename File"
    },
  }
}

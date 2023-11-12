-- See https://github.com/neovim/neovim/issues/20784#issuecomment-1288085253
-- Maybe later it would be worth using: https://github.com/antosha417/nvim-lsp-file-operations
local function rename_file()
  local source_file, target_file

  vim.ui.input({
    prompt = "Source : ",
    completion = "file",
    default = vim.api.nvim_buf_get_name(0)
  },
  function(input)
    source_file = input
  end)

  vim.ui.input({
    prompt = "Target : ",
    completion = "file",
    default = source_file
  },
  function(input)
    target_file = input
  end)

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


return {
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
      tsserver = {
        maxTsServerMemory = 9216
      }
    }
  },
  commands = {
    RenameFile = {
      rename_file,
      description = "Rename File"
    },
  }
}

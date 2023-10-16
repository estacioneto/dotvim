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
  }
}

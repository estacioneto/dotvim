return {
  'nvim-java/nvim-java',
  config = function()
    require('java').setup()

    vim.lsp.enable 'jdtls'

    local ok, java_home =
      pcall(vim.fn.system, { '/usr/libexec/java_home', '-v', '17' })

    if not ok then
      return
    end

    vim.lsp.config('jdtls', {
      settings = {
        java = {
          configuration = {
            runtimes = {
              {
                name = 'JavaSE-17',
                path = java_home,
                default = true,
              },
            },
          },
        },
      },
    })
  end,
}

vim.filetype.add {
  extension = {
    ['http'] = 'http',
  },
}

return {
  {
    'mistweaverco/kulala.nvim',
    opts = {
      urlencode = "skipencoded",
      default_env = 'local',
      contenttypes = {
        ['application/xml'] = {
          ft = 'xml',
          formatter = { 'prettier', '--parser', 'xml' },
          pathresolver = {},
        },
        ['text/html'] = {
          ft = 'html',
          formatter = { 'prettier', '--parser', 'html' },
          pathresolver = {},
        },
      },
    },
  },
}

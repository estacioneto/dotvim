require('estacio.set')
require('estacio.keymaps')
require('estacio.commands')
require('estacio.autocmd')
require('estacio.messages')

require('estacio.lazy')

require('estacio.colors')

require('estacio.lsp.config')

local git = require('estacio.git')

git.set_keymaps()
git.set_commands()

local fzf = require('estacio.fzf')
fzf.setup()

pcall(function()
  require('estacio.klarna')
end)

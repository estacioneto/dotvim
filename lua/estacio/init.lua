require('estacio.plugins')
require('estacio.set')
require('estacio.commands')
require('estacio.keymaps')
require('estacio.autocmd')
require('estacio.tips')

local git = require('estacio.git')
git.set_keymaps()
git.set_commands()

require('estacio.klarna')

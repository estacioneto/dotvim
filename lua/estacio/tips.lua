vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('vimtip', { clear = true }),
  callback = function()
    local job = require('plenary.job')
    job:new({
      command = 'curl',
      args = { 'https://vtip.43z.one' },
      on_exit = function(result, exit_code)
        local res = table.concat(result:result())

        if exit_code ~= 0 then
          res = 'Error fetching tip: '..res
        end

        vim.schedule(function()
          vim.notify(res, 2, { title = 'Tip!' })
        end)
      end
    })
    :start()
  end
})

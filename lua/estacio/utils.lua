local M = {}

function M.run_async_cmd(command, opts, next)
  opts = opts or {}
  opts.title = opts.title or 'Utils'

  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  local err_output = {}
  local output = {}

  local full_command = command .. ' ' .. table.concat(opts.args, ' ')

  local _, pid = vim.loop.spawn(
    command,
    {
      args = opts.args,
      stdio = { nil, stdout, stderr },
    },
    vim.schedule_wrap(function(code)
      if code ~= 0 then
        vim.notify(
          'Error executing command: '
            .. full_command
            .. '\nError code: '
            .. code
            .. '\nOutput: '
            .. table.concat(err_output, '\n'),
          vim.log.levels.ERROR,
          { title = opts.title }
        )
      else
        vim.notify(
          'Command executed successfully: '
            .. full_command
            .. '\nOutput: '
            .. table.concat(output, '\n'),
          vim.log.levels.INFO,
          { title = opts.title }
        )
      end

      if next then
        next(code, table.concat(output, '\n'), table.concat(err_output, '\n'))
      end
    end)
  )

  vim.notify(
    'Executing command: ' .. full_command .. '... (pid: ' .. pid .. ')',
    vim.log.levels.INFO,
    { title = opts.title }
  )

  stdout:read_start(function(err, chunk)
    assert(not err, err)
    if chunk then
      table.insert(output, chunk)
    else
      stdout:close()
    end
  end)

  stderr:read_start(function(err, chunk)
    assert(not err, err)
    if chunk then
      table.insert(err_output, chunk)
    else
      stderr:close()
    end
  end)
end

-- Add command to kill process by pid
function M.kill_process(pid)
  vim.loop.kill(pid, 15)
end

vim.api.nvim_create_user_command('RunAsync', function(opts)
  local split_args = vim.split(opts.args, ' ')
  local command, args =
    split_args[1], vim.list_slice(split_args, 2, #split_args)

  M.run_async_cmd(command, { args = args, title = 'Command' })
end, {
  nargs = '+',
})

vim.api.nvim_create_user_command('Kill', M.kill_process, {
  nargs = 1,
  complete = 'customlist,v:lua.require"utils".get_pids',
})

return M

local M = {}

function M.run_async_cmd(command, args, next)
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  local err_output = {}
  local output = {}

  local full_command = command .. ' ' .. table.concat(args, ' ')

  vim.notify('Executing command: '..full_command..'...', vim.log.levels.INFO, { title = 'Git' })

  vim.loop.spawn(command, {
    args = args,
    stdio = { nil, stdout, stderr },
  }, vim.schedule_wrap(function(code)
    if code ~= 0 then
      vim.notify('Error executing command: ' .. full_command .. '\nError code: ' .. code .. '\nOutput: ' .. table.concat(err_output, '\n'), vim.log.levels.ERROR, { title = 'Git' })
    else
      vim.notify('Command executed successfully: ' .. full_command .. '\nOutput: ' .. table.concat(output, '\n'), vim.log.levels.INFO, { title = 'Git' })
    end

    if next then
      next(code, table.concat(output, '\n'), table.concat(err_output, '\n'))
    end
  end))

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

return M

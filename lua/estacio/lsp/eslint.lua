--- Search for package.json files that contain eslint as a dependency
--- @returns string | nil
local function get_eslint_closest_dir()
  local cwd = vim.fn.getcwd()
  local eslint_node_modules = vim.fn.finddir('node_modules/eslint', cwd .. ';')

  if eslint_node_modules == '' then
    return nil
  end

  if eslint_node_modules == 'node_modules/eslint' then
    return cwd
  end

  -- Strip the node_modules/eslint part
  return eslint_node_modules:match '(.*)/node_modules/eslint'
end

return {
  single_file_support = true,
  on_new_config = function(config, new_root_dir)
    local eslint_closest_dir = get_eslint_closest_dir()

    -- If new_root_dir is not a subdirectory of eslint_closest_dir, set new_root_dir to eslint_closest_dir
    if
      eslint_closest_dir
      and new_root_dir:find(eslint_closest_dir, 1, true) ~= 1
    then
      new_root_dir = eslint_closest_dir
    end

    -- See https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/eslint.lua

    -- The "workspaceFolder" is a VSCode concept. It limits how far the
    -- server will traverse the file system when locating the ESLint config
    -- file (e.g., .eslintrc).
    config.settings.workspaceFolder = {
      uri = new_root_dir,
      name = vim.fn.fnamemodify(new_root_dir, ':t'),
    }

    -- Support flat config
    if
      vim.fn.filereadable(new_root_dir .. '/eslint.config.js') == 1
      or vim.fn.filereadable(new_root_dir .. '/eslint.config.mjs') == 1
      or vim.fn.filereadable(new_root_dir .. '/eslint.config.cjs') == 1
      or vim.fn.filereadable(new_root_dir .. '/eslint.config.ts') == 1
      or vim.fn.filereadable(new_root_dir .. '/eslint.config.mts') == 1
      or vim.fn.filereadable(new_root_dir .. '/eslint.config.cts') == 1
    then
      config.settings.experimental.useFlatConfig = true
    end

    -- Support Yarn2 (PnP) projects
    local pnp_cjs = new_root_dir .. '/.pnp.cjs'
    local pnp_js = new_root_dir .. '/.pnp.js'
    if vim.loop.fs_stat(pnp_cjs) or vim.loop.fs_stat(pnp_js) then
      config.cmd = vim.list_extend({ 'yarn', 'exec' }, config.cmd)
    end
  end,
}

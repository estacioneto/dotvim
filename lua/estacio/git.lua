local M = {}

function M.get_git_root()
  local handle = io.popen("git rev-parse --show-toplevel")
  if handle == nil then
    return ""
  end

  local result = handle:read("*a")
  handle:close()

  return result
end

-- Stash URL
local function get_file()
  -- get the relative file path
  local git_root_dir = M.get_git_root():match("^.*/")
  local file_path = vim.fn.expand('%:p')
  local relative_file_path = file_path:sub(#git_root_dir+1)

  -- Remove the first folder from the relative file path
  local pos = relative_file_path:find("/")

  if pos then
    relative_file_path = relative_file_path:sub(pos+1)
  end

  return relative_file_path
end

local function get_remote()
  -- get the remote url
  local handle = io.popen("git config --get remote.origin.url")
  if handle == nil then
    return ""
  end
  local result = handle:read("*a")

  if result == "" then
    print("No remote found")
    return ""
  end

  handle:close()
  local _, _, domain, _, group, repo = result:match("(ssh://)([^@]+)@([^:]+):(%d+)/([^/]+)/([^/]+).git")

  return ("https://%s/projects/%s/repos/%s/browse/"):format(domain, group:upper(), repo)
end

local function sturl()
  local fp = get_file()
  local rp = get_remote()
  local path = rp .. fp

  -- Copy URL to clipboard in MacOS
  os.execute("echo '" .. path .. "' | pbcopy")

  print("Copied to clipboard: " .. path)
end

function M.set_keymaps()
  -- Keymap: Copy stash url to clipboard
  vim.keymap.set("n", "<leader>rurl", sturl)
end

function M.is_small_repo()
  if M.get_git_root() == "" then
    return
  end
  -- If we're inside a Git repository, check the size-pack
  local handle = io.popen("git count-objects -v")
  if handle == nil then
    return
  end

  local result = handle:read("*a")
  handle:close()

  for line in result:gmatch("[^\r\n]+") do
    if line:find("size%-pack:") then
      local size_pack = tonumber(line:match("%d+"))
      if size_pack then
        -- Convert KB to MB and check if it's less than 500MB
        return (size_pack / 1024) < 500
      end
    end
  end

  -- Return false if size-pack is not found or not less than 500MB
  return false
end

return M

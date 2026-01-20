-- lua/config/state.lua

local M = {}
local fn = vim.fn
local uv = vim.loop
local notify = vim.notify
local log = vim.log.levels

local state_file = fn.stdpath("state") .. "/provider_state.json"
local uv_tools_dir = fn.expand("~/.local/share/uv/tools")
local python_tool = uv_tools_dir .. "/pynvim/bin/python"

-- Ensure directory exists
local function ensure_dir(path)
  if fn.isdirectory(path) == 0 then
    fn.mkdir(path, "p")
  end
end

local function read_state()
  ensure_dir(fn.stdpath("state"))
  local fd = uv.fs_open(state_file, "r", 438)
  if not fd then
    return { python = { version = "" }, nvim_version = "" }
  end
  local stat = uv.fs_fstat(fd)
  local data = uv.fs_read(fd, stat.size, 0)
  uv.fs_close(fd)
  local ok, decoded = pcall(vim.json.decode, data)
  return ok and decoded or { python = { version = "" }, nvim_version = "" }
end

local function write_state(tbl)
  local fd = uv.fs_open(state_file, "w", 438)
  if fd then
    uv.fs_write(fd, vim.json.encode(tbl), 0)
    uv.fs_close(fd)
  end
end

-- Ensure Python provider exists and return the executable path
function M.ensure_python_provider()
  -- If already installed
  if fn.executable(python_tool) == 1 then
    return python_tool
  end

  -- Install via uv tool
  notify("Installing pynvim via uv tool install...", log.INFO)
  local result = fn.system({ "uv", "tool", "install", "pynvim" })

  if vim.v.shell_error ~= 0 then
    notify("Failed to install pynvim: " .. result, log.ERROR)
    return nil
  end

  return python_tool
end

-- Reinstall provider when Neovim version updates
function M.sync_providers()
  local state = read_state()
  local ver = vim.version()
  local current_ver = ("%d.%d.%d"):format(ver.major, ver.minor, ver.patch)

  if state.nvim_version ~= current_ver then
    notify("Neovim updated → refreshing Python provider", log.INFO)
    fn.jobstart({ "uv", "tool", "upgrade", "pynvim" })
    state.nvim_version = current_ver
    write_state(state)
  end
end

return M

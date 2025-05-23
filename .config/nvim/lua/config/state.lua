-- $XDG_CONFIG_HOME/nvim/lua/config/state.lua

local M = {}
local uv = vim.loop
local fn = vim.fn
local env = vim.env
local notify = vim.notify
local log_levels = vim.log.levels
local json = vim.json
local state_file = string.format("%s/nvim/lang_state.json", env.XDG_STATE_HOME or fn.expand("~/.local/state"))

-- Ensure state directory exists
local function ensure_state_dir()
  local state_dir = fn.fnamemodify(state_file, ":h")
  if fn.isdirectory(state_dir) == 0 then
    fn.mkdir(state_dir, "p")
  end
end

-- Read state file
function M.read_state()
  ensure_state_dir()
  local fd = uv.fs_open(state_file, "r", 438)
  if not fd then
    return {}
  end

  local stat = uv.fs_fstat(fd)
  local data = uv.fs_read(fd, stat.size, 0)
  uv.fs_close(fd)

  local ok, parsed = pcall(json.decode, data)
  if not ok then
    notify("Failed to parse state file", log_levels.ERROR)
    return {}
  end
  return parsed
end

-- Get provider path for a language
function M.get_provider_path(lang)
  local state = M.read_state()
  return state[lang] and state[lang].provider_path or nil
end

-- Get version for a language
function M.get_version(lang)
  local state = M.read_state()
  return state[lang] and state[lang].version or nil
end

-- Check if language is installed and configured
function M.is_language_ready(lang)
  local state = M.read_state()
  return state[lang] and state[lang].version ~= nil
end

return M

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
    -- Initialize with empty state if file doesn't exist
    return { python = {}, go = {}, rust = {}, node = {} }
  end

  local stat = uv.fs_fstat(fd)
  local data = uv.fs_read(fd, stat.size, 0)
  uv.fs_close(fd)

  local ok, parsed = pcall(json.decode, data)
  if not ok then
    notify("Failed to parse state file", log_levels.ERROR)
    return { python = {}, go = {}, rust = {}, node = {} }
  end
  return parsed
end

-- Get provider path for a language
function M.get_provider_path(lang)
  local state = M.read_state()
  if not state[lang] or not state[lang].provider_path then
    notify(string.format("No provider path found for %s", lang), log_levels.WARN)
    return nil
  end
  return state[lang].provider_path
end

-- Get version for a language
function M.get_version(lang)
  local state = M.read_state()
  return state[lang] and state[lang].version or nil
end

-- Check if language is installed and configured
function M.is_language_ready(lang)
  local state = M.read_state()
  if not state[lang] then
    return false
  end

  -- Check version exists
  if not state[lang].version then
    return false
  end

  -- Check provider path for languages that need it
  if lang == "python" or lang == "node" then
    if not state[lang].provider_path or not uv.fs_stat(state[lang].provider_path) then
      return false
    end
  end

  return true
end

-- Validate provider configuration
function M.validate_provider(lang)
  if not M.is_language_ready(lang) then
    notify(string.format("%s provider not properly configured", lang), log_levels.WARN)
    return false
  end

  -- Additional checks for specific languages
  if lang == "python" then
    local provider_path = M.get_provider_path(lang)
    if not provider_path or not fn.executable(provider_path) then
      notify("Python provider not executable", log_levels.ERROR)
      return false
    end
  elseif lang == "node" then
    local provider_path = M.get_provider_path(lang)
    if not provider_path or not fn.executable(provider_path) then
      notify("Node provider not executable", log_levels.ERROR)
      return false
    end
  end

  return true
end

-- Check if providers need updating
function M.check_providers()
  local state = M.read_state()
  local needs_update = false

  for lang, config in pairs(state) do
    if not M.validate_provider(lang) then
      needs_update = true
      notify(string.format("%s provider needs update", lang), log_levels.INFO)
    end
  end

  return needs_update
end

return M

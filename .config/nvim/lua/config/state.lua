-- lua/config/state.lua
local M = {}

local state_dir = vim.env.XDG_STATE_HOME or (os.getenv("HOME") .. "/.local/state")
local nvim_state_dir = state_dir .. "/nvim"
local state_file = nvim_state_dir .. "/provider_state.json"

function M.ensure_state_dir()
  -- Create state directory if it doesn't exist
  if vim.fn.isdirectory(nvim_state_dir) == 0 then
    vim.fn.mkdir(nvim_state_dir, "p")
  end
end

function M.read_state()
  M.ensure_state_dir()
  if vim.fn.filereadable(state_file) == 1 then
    local content = vim.fn.readfile(state_file)
    if #content > 0 then
      return vim.json.decode(content[1])
    end
  end
  return {}
end

function M.write_state(data)
  M.ensure_state_dir()
  local encoded = vim.json.encode(data)
  vim.fn.writefile({ encoded }, state_file)
end

function M.update_python_state(version, provider_path)
  local state = M.read_state()
  state.python = {
    version = version,
    provider_path = provider_path,
  }
  M.write_state(state)
end

return M

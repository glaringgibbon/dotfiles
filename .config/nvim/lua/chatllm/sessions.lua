-- lua/chatllm/sessions.lua
-- Session persistence for ChatLLM (Phase 6.1 MVP)

local M = {}

local uv = vim.loop

-- Determine base paths
local function get_base_dir()
  local data = vim.fn.stdpath("data") -- e.g. ~/.local/share/nvim
  return data .. "/chatllm"
end

local function ensure_dir(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

local function get_project_name()
  -- Phase 6.1: simple project detection (can be extended later)
  -- Try git root name, else cwd basename, else "default"
  local ok, root = pcall(function()
    return vim.fn.getcwd()
  end)
  if not ok or not root or root == "" then
    return "default"
  end

  -- Try git repo name
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if git_root and git_root ~= "" and vim.v.shell_error == 0 then
    return vim.fn.fnamemodify(git_root, ":t")
  end

  -- Fallback: directory name
  local name = vim.fn.fnamemodify(root, ":t")
  return name ~= "" and name or "default"
end

local function get_project_dir(project)
  local base = get_base_dir()
  local proj = base .. "/projects/" .. project
  ensure_dir(proj)
  ensure_dir(proj .. "/sessions")
  return proj
end

local function get_last_session_path(project)
  local proj = get_project_dir(project)
  return proj .. "/last_session"
end

local function write_file(path, content)
  local fd = uv.fs_open(path, "w", 420) -- 0644
  if not fd then
    return nil, "Failed to open file for writing: " .. path
  end
  uv.fs_write(fd, content, -1)
  uv.fs_close(fd)
  return true
end

local function read_file(path)
  local fd = uv.fs_open(path, "r", 420)
  if not fd then
    return nil, "Failed to open file for reading: " .. path
  end
  local stat = uv.fs_fstat(fd)
  local data = uv.fs_read(fd, stat.size, 0)
  uv.fs_close(fd)
  return data
end

-- Generate a new session id (timestamp-based)
local function new_session_id()
  return tostring(os.time())
end

-- Public: save a session for current project
-- messages: array of { role, content, timestamp }
function M.save_session(messages)
  local project = get_project_name()
  local proj_dir = get_project_dir(project)
  local sessions_dir = proj_dir .. "/sessions"

  local id
  local last_path = get_last_session_path(project)
  -- Try to reuse existing id if last_session points to a valid file
  local last_id = nil
  if vim.fn.filereadable(last_path) == 1 then
    local content = vim.fn.readfile(last_path)
    last_id = content[1]
  end

  if last_id and last_id ~= "" and vim.fn.filereadable(sessions_dir .. "/" .. last_id .. ".lua") == 1 then
    id = last_id
  else
    id = new_session_id()
  end

  local session = {
    id = id,
    project = project,
    updated = os.time(),
    messages = messages or {},
  }

  local session_path = sessions_dir .. "/" .. id .. ".lua"

  local ok, serialized = pcall(vim.inspect, session)
  if not ok then
    return nil, "Failed to serialize session: " .. tostring(serialized)
  end

  local lua_content = "return " .. serialized .. "\n"
  local okw, errw = write_file(session_path, lua_content)
  if not okw then
    return nil, errw
  end

  -- Update last_session pointer
  local okp, errp = write_file(last_path, id .. "\n")
  if not okp then
    return nil, errp
  end

  return id
end

-- Public: load last session for current project
function M.load_last_session()
  local project = get_project_name()
  local proj_dir = get_project_dir(project)
  local sessions_dir = proj_dir .. "/sessions"
  local last_path = get_last_session_path(project)

  if vim.fn.filereadable(last_path) == 0 then
    return nil, "No last session for project"
  end

  local content = vim.fn.readfile(last_path)
  local id = content[1]
  if not id or id == "" then
    return nil, "last_session file empty"
  end

  local session_path = sessions_dir .. "/" .. id .. ".lua"
  if vim.fn.filereadable(session_path) == 0 then
    return nil, "Session file not found: " .. session_path
  end

  local ok, session = pcall(dofile, session_path)
  if not ok or type(session) ~= "table" then
    return nil, "Failed to load session file: " .. tostring(session)
  end

  return session
end

-- Public: create a new empty session for current project and persist it
function M.new_session()
  local project = get_project_name()
  local proj_dir = get_project_dir(project)
  local sessions_dir = proj_dir .. "/sessions"

  local id = new_session_id()
  local session = {
    id = id,
    project = project,
    updated = os.time(),
    messages = {},
  }

  local session_path = sessions_dir .. "/" .. id .. ".lua"
  local ok, serialized = pcall(vim.inspect, session)
  if not ok then
    return nil, "Failed to serialize new session: " .. tostring(serialized)
  end

  local lua_content = "return " .. serialized .. "\n"
  local okw, errw = write_file(session_path, lua_content)
  if not okw then
    return nil, errw
  end

  local last_path = get_last_session_path(project)
  local okp, errp = write_file(last_path, id .. "\n")
  if not okp then
    return nil, errp
  end

  return session
end

return M

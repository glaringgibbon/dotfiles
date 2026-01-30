-- lua/chatllm/ui.lua
-- ChatLLM UI Management
-- Handles buffer creation, window management, and display
-- TODO (Phase 6.2): Handle tmux-restored chat buffers
-- Detect when chat buffer is restored but empty
-- Show notification or auto-load last session on buffer focus
-- Ensure no surprising behavior during tmux restore
-- TODO (Phase 8): Replace vim.ui.input with floating editor for <leader>ac
-- When user input exceeds ~80 chars, open floating window instead of input box
-- Reuse editor.lua's open_prompt_editor pattern for consistencylocal M = {}

local sessions = require("chatllm.sessions")

local M = {}

-- State: track the ChatLLM buffer and window
local state = {
  buf = nil,
  win = nil,
  chat_history = {}, -- Store conversation history in-memory
  initialized = false, -- track if we've attempted session restore
}

-- Internal: restore history from a loaded session into buffer + state
local function restore_from_session(session)
  state.chat_history = session.messages or {}

  local buf = state.buf or vim.api.nvim_create_buf(false, true)

  state.buf = buf
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")
  vim.api.nvim_buf_set_option(buf, "swapfile", false)
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
  vim.api.nvim_buf_set_name(buf, "ChatLLM")

  local lines = {}
  for _, msg in ipairs(state.chat_history) do
    if msg.role == "user" then
      table.insert(lines, "**You:**")
    else
      table.insert(lines, "**ChatLLM:**")
    end
    for line in (msg.content or ""):gmatch("[^\n]+") do
      table.insert(lines, line)
    end
    table.insert(lines, "")
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

-- Internal: persist current history to disk
local function persist_history()
  local ok, err = sessions.save_session(state.chat_history)
  if not ok and err then
    vim.notify("[ChatLLM] Failed to save session: " .. tostring(err), vim.log.levels.WARN)
  end
end

-- Create or get the ChatLLM buffer
local function get_or_create_buffer()
  -- If buffer exists and is valid, return it
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    return state.buf
  end

  -- Attempt one-time session restore on first buffer creation
  if not state.initialized then
    state.initialized = true
    local session, err = sessions.load_last_session()
    if session then
      restore_from_session(session)
      return state.buf
    else
      -- No session: continue to create fresh buffer
      -- (err is expected on first use; no need to notify)
    end
  end

  -- Create new empty buffer
  state.buf = vim.api.nvim_create_buf(false, true)

  -- Set buffer options
  vim.api.nvim_buf_set_option(state.buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(state.buf, "bufhidden", "hide")
  vim.api.nvim_buf_set_option(state.buf, "swapfile", false)
  vim.api.nvim_buf_set_option(state.buf, "filetype", "markdown")

  -- Set buffer name
  vim.api.nvim_buf_set_name(state.buf, "ChatLLM")

  return state.buf
end

-- Open or toggle the ChatLLM window (vertical split on the right)
local function open_window()
  local buf = get_or_create_buffer()

  -- If window already exists and is valid, close it
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, false)
    state.win = nil
    return false -- Window was closed
  end

  -- Get current window dimensions
  local current_win = vim.api.nvim_get_current_win()
  local editor_width = vim.api.nvim_win_get_width(current_win)

  -- Calculate split width (40% of editor width, minimum 40 columns)
  local split_width = math.max(40, math.floor(editor_width * 0.4))

  -- Open vertical split on the right
  vim.cmd("botright vsplit")
  state.win = vim.api.nvim_get_current_win()

  -- Set window width
  vim.api.nvim_win_set_width(state.win, split_width)

  -- Attach buffer to window
  vim.api.nvim_win_set_buf(state.win, buf)

  -- Set window options
  vim.api.nvim_win_set_option(state.win, "wrap", true)
  vim.api.nvim_win_set_option(state.win, "linebreak", true)

  -- Move cursor back to the original window
  vim.api.nvim_set_current_win(current_win)

  return true -- Window was opened
end

-- Append text to the ChatLLM buffer
local function append_to_buffer(text, role)
  role = role or "assistant"
  local buf = get_or_create_buffer()

  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  -- Format the message with role prefix
  local formatted_text = {}
  if role == "user" then
    table.insert(formatted_text, "**You:**")
  elseif role == "assistant" then
    table.insert(formatted_text, "**ChatLLM:**")
  end

  -- Split text into lines and add to buffer
  for line in text:gmatch("[^\n]+") do
    table.insert(formatted_text, line)
  end
  table.insert(formatted_text, "") -- Add blank line for spacing

  -- Append to buffer
  vim.api.nvim_buf_set_lines(buf, -1, -1, false, formatted_text)

  -- Store in history
  table.insert(state.chat_history, {
    role = role,
    content = text,
    timestamp = os.time(),
  })

  -- Persist after each message
  persist_history()
end

-- Clear the ChatLLM buffer
local function clear_buffer()
  local buf = get_or_create_buffer()

  if vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
    state.chat_history = {}
    persist_history()
  end
end

-- Show a loading indicator
local function show_loading()
  local buf = get_or_create_buffer()

  if vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "⏳ Loading...", "" })
  end
end

-- Remove the loading indicator
local function remove_loading()
  local buf = get_or_create_buffer()

  if vim.api.nvim_buf_is_valid(buf) then
    local line_count = vim.api.nvim_buf_line_count(buf)
    if line_count >= 2 then
      local lines = vim.api.nvim_buf_get_lines(buf, line_count - 2, line_count, false)
      if lines[1] and lines[1]:match("⏳ Loading") then
        vim.api.nvim_buf_set_lines(buf, line_count - 2, line_count, false, {})
      end
    end
  end
end

-- Public API: Toggle the ChatLLM window
function M.toggle_window()
  return open_window()
end

-- Public API: Append message to buffer
function M.append_message(text, role)
  append_to_buffer(text, role)
end

-- Public API: Show loading state
function M.show_loading()
  show_loading()
end

-- Public API: Remove loading state
function M.remove_loading()
  remove_loading()
end

-- Public API: Clear buffer
function M.clear()
  clear_buffer()
end

-- Public API: Get chat history
function M.get_history()
  return state.chat_history
end

-- Public API: Get buffer number
function M.get_buffer()
  return state.buf
end

-- Public API: Get window number
function M.get_window()
  return state.win
end

return M

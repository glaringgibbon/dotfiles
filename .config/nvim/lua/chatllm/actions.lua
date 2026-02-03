-- lua/chatllm/actions.lua
-- TODO (Phase 9): Implement Treesitter-based context selection
-- Allow user to select code by AST node (function, class, block, etc.)
-- Command: <leader>ats (AI Treesitter Select)
-- Fallback to visual selection if Treesitter unavailable
-- Benefits: More precise selection, language-aware, no manual highlighting
local client = require("chatllm.client")
local ui = require("chatllm.ui")
local models = require("chatllm.models")
local prompts = require("chatllm.prompts")

local M = {}

-- Helper: get selected text or entire buffer
local function get_context()
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    -- Visual mode: get selection (linewise for now)
    local start_line = vim.fn.getpos("'<")[2]
    local end_line = vim.fn.getpos("'>")[2]
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    return table.concat(lines, "\n")
  else
    -- Normal mode: get entire buffer
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    return table.concat(lines, "\n")
  end
end

local function get_snacks()
  -- LazyVim typically provides global Snacks, but be robust.
  if _G.Snacks then
    return _G.Snacks
  end
  local ok, snacks = pcall(require, "snacks")
  if ok then
    return snacks
  end
  return nil
end

-- Generic: run any prompt from the prompts system
function M.run_prompt(prompt_id)
  local prompt_data = prompts.get(prompt_id)
  if not prompt_data then
    vim.notify("Prompt '" .. prompt_id .. "' not found", vim.log.levels.ERROR)
    return
  end

  local context = get_context()
  if context == "" then
    vim.notify("No code selected or buffer is empty", vim.log.levels.WARN)
    return
  end

  if not ui.get_window() then
    ui.toggle_window()
  end

  local full_prompt = prompt_data.prompt .. context

  ui.show_loading()

  vim.defer_fn(function()
    local response, err = client.ask(full_prompt, {
      model = models.get_model(),
    })

    ui.remove_loading()

    if err then
      ui.append_message("Error: " .. err, "assistant")
    else
      ui.append_message(response, "assistant")
    end
  end, 10)
end

-- Convenience functions for common prompts
function M.explain()
  M.run_prompt("code.explain")
end

function M.fix()
  M.run_prompt("code.patch")
end

function M.refactor()
  M.run_prompt("refactor.readability")
end

-- Multi-turn chat
function M.chat()
  vim.ui.input({ prompt = "ChatLLM Query: " }, function(input)
    if not input or input == "" then
      return
    end

    if not ui.get_window() then
      ui.toggle_window()
    end

    ui.append_message(input, "user")

    local history = ui.get_history()
    local messages = {}

    table.insert(messages, {
      role = "system",
      content = "You are a helpful senior software engineer and technical assistant.",
    })

    for _, msg in ipairs(history) do
      table.insert(messages, {
        role = msg.role,
        content = msg.content,
      })
    end

    ui.show_loading()

    vim.defer_fn(function()
      local response, err = client.chat(messages, {
        model = models.get_model(),
      })

      ui.remove_loading()

      if err then
        ui.append_message("Error: " .. err, "assistant")
      else
        ui.append_message(response, "assistant")
      end
    end, 10)
  end)
end

-- Session picker (Snacks)
function M.pick_session()
  local Snacks = get_snacks()
  if not Snacks or not Snacks.picker then
    vim.notify("ChatLLM: Snacks.picker not available", vim.log.levels.ERROR)
    return
  end

  local sessions = require("chatllm.sessions")
  local items = sessions.list_sessions()

  if #items == 0 then
    vim.notify("No saved sessions found for this project", vim.log.levels.WARN)
    return
  end

  Snacks.picker({
    source = "ChatLLM Sessions",
    items = items,

    -- Prevent Snacks from treating input as executable commands (fixes random terminal popups)
    execute = false,
    preview = { execute = false },

    format = function(item)
      local t = os.date("%Y-%m-%d %H:%M", tonumber(item.updated) or 0)
      local label = item.text or item.summary or item.id or "(unnamed)"
      return {
        { t, "SnacksPickerTime" },
        { "  " },
        { label, "SnacksPickerText" },
      }
    end,

    confirm = function(picker, item)
      picker:close()
      if not item then
        return
      end

      local session, err = sessions.load_session(item.id)
      if not session then
        vim.notify("ChatLLM: failed to load session: " .. tostring(err), vim.log.levels.ERROR)
        return
      end

      ui.restore_session(session)
      vim.notify("ChatLLM: Loaded session " .. tostring(item.id), vim.log.levels.INFO)
    end,
    previewer = function(ctx)
      local ok, session = pcall(dofile, ctx.item.file)
      if not ok or type(session) ~= "table" then
        ctx.preview:set_lines({ "Failed to load session: " .. tostring(session) })
        return
      end

      local lines = {}
      for _, msg in ipairs(session.messages or {}) do
        table.insert(lines, "# " .. tostring((msg.role or "unknown")):upper())
        table.insert(lines, msg.content or "")
        table.insert(lines, "")
      end

      ctx.preview:set_lines(lines)
      ctx.preview:highlight({ ft = "markdown" })
    end,
  }) -- <-- This was the missing closing parenthesis + end
end

-- Start a new empty session for this project
function M.new_session()
  local sessions = require("chatllm.sessions")
  local session, err = sessions.new_session()
  if not session then
    vim.notify("ChatLLM: Failed to create new session: " .. tostring(err), vim.log.levels.ERROR)
    return
  end

  ui.clear()
  vim.notify("ChatLLM: Started new session (" .. tostring(session.id) .. ")", vim.log.levels.INFO)
end

-- Delete a session (separate picker, safer than binding delete inside the main picker initially)
function M.delete_session()
  local Snacks = get_snacks()
  if not Snacks or not Snacks.picker then
    vim.notify("ChatLLM: Snacks.picker not available", vim.log.levels.ERROR)
    return
  end

  local sessions = require("chatllm.sessions")
  local items = sessions.list_sessions()

  if #items == 0 then
    vim.notify("No saved sessions to delete", vim.log.levels.WARN)
    return
  end

  Snacks.picker({
    source = "Delete ChatLLM Session",
    items = items,

    execute = false,
    preview = { execute = false },

    format = function(item)
      local t = os.date("%Y-%m-%d %H:%M", tonumber(item.updated) or 0)
      local label = item.text or item.summary or item.id or "(unnamed)"
      return {
        { t, "SnacksPickerTime" },
        { "  " },
        { label, "SnacksPickerText" },
      }
    end,

    confirm = function(picker, item)
      picker:close()
      if not item then
        return
      end

      local label = item.text or item.summary or ""
      local ok = vim.fn.confirm(("Delete session %s?\n\n%s"):format(tostring(item.id), tostring(label)), "&Yes\n&No", 2)
      if ok ~= 1 then
        return
      end

      local ok_rm, err = os.remove(item.file)
      if not ok_rm then
        vim.notify("ChatLLM: Failed to delete session: " .. tostring(err), vim.log.levels.ERROR)
        return
      end

      vim.notify("ChatLLM: Deleted session " .. tostring(item.id), vim.log.levels.INFO)
    end,
    previewer = function(ctx)
      local ok, session = pcall(dofile, ctx.item.file)
      if not ok or type(session) ~= "table" then
        ctx.preview:set_lines({ "Failed to load session: " .. tostring(session) })
        return
      end

      local lines = {}
      for _, msg in ipairs(session.messages or {}) do
        table.insert(lines, "# " .. tostring((msg.role or "unknown")):upper())
        table.insert(lines, msg.content or "")
        table.insert(lines, "")
      end

      ctx.preview:set_lines(lines)
      ctx.preview:highlight({ ft = "markdown" })
    end,
  }) -- <-- This was also missing
end

return M

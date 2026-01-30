-- lua/chatllm/actions.lua
-- TODO (Phase 9): Implement Treesitter-based context selection
-- Allow user to select code by AST node (function, class, block, etc.)
-- Command: <leader>ats (AI Treesitter Select)
-- Fallback to visual selection if Treesitter unavailable
-- Benefits: More precise selection, language-aware, no manual highlightinglocal client = require("chatllm.client")
local ui = require("chatllm.ui")
local models = require("chatllm.models")
local prompts = require("chatllm.prompts")

local M = {}

-- Helper: get selected text or entire buffer
local function get_context()
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    -- Visual mode: get selection
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

-- Generic: run any prompt from the prompts system
function M.run_prompt(prompt_id)
  -- FIX: Use get_by_id instead of get
  local prompt_data = prompts.get_by_id(prompt_id)
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

  ui.show_loading()

  -- FIX: Use client.chat to support system/user roles
  local messages = {
    { role = "system", content = prompt_data.system or "You are a helpful senior software engineer." },
    { role = "user", content = prompt_data.prompt .. "\n\nCode:\n" .. context },
  }

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

-- Multi-turn chat (unchanged from Phase 4)
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

return M

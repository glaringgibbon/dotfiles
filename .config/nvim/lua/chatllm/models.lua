-- lua/chatllm/models.lua
local client = require("chatllm.client")

local M = {}

-- Hardcoded list for MVP. We will replace this with API-driven discovery later.
M.llm_models = {
  "route-llm",
  "claude-4-5-sonnet",
  "claude-4-5-haiku",
  "claude-4-5-opus",
  "gpt-5.2",
  "gpt-5.1",
  "gpt-4o",
  "gemini-3-pro",
  "gemini-3-flash",
}

-- Track current model (session-level)
M.current_model = "route-llm"

function M.set_model(name)
  M.current_model = name
  client.setup({ model = name })
  vim.notify("ChatLLM: model set to " .. name, vim.log.levels.INFO)
end

function M.get_model()
  return M.current_model
end

-- Simple picker using vim.ui.select
function M.pick_model()
  vim.ui.select(M.llm_models, {
    prompt = "Select ChatLLM model:",
    format_item = function(item)
      return item
    end,
  }, function(choice)
    if choice then
      M.set_model(choice)
    end
  end)
end

return M

-- lua/chatllm/client.lua
-- ChatLLM API Client for Neovim
-- Handles communication with RouteLLM API

local M = {}

-- Configuration
local config = {
  api_base = "https://routellm.abacus.ai/v1",
  model = "claude-sonnet-4.5",
  temperature = 0.7,
  max_tokens = 2048,
}

-- Load API key from environment or .env file
local function get_api_key()
  -- Check environment first
  local key = os.getenv("CHATLLM_API_KEY")
  if key and key ~= "" then
    return key
  end

  -- Fall back to .env file
  local env_file = vim.fn.expand("~/.config/chatllm/.env")
  if vim.fn.filereadable(env_file) == 1 then
    for line in io.lines(env_file) do
      if line:match("^CHATLLM_API_KEY=") then
        key = line:match('CHATLLM_API_KEY="?([^"]+)"?')
        if key and key ~= "" then
          return key
        end
      end
    end
  end

  return nil
end

-- Internal: make HTTP request to ChatLLM API
local function request(opts)
  opts = opts or {}
  local model = opts.model or config.model
  local temperature = opts.temperature or config.temperature
  local max_tokens = opts.max_tokens or config.max_tokens

  local api_key = get_api_key()
  if not api_key then
    return nil, "CHATLLM_API_KEY not found in environment or ~/.config/chatllm/.env"
  end

  local messages = opts.messages
  local prompt = opts.prompt

  if not messages then
    if not prompt or prompt == "" then
      return nil, "Either messages or prompt must be provided"
    end
    messages = {
      { role = "user", content = prompt },
    }
  end

  local payload = {
    model = model,
    messages = messages,
    temperature = temperature,
    max_tokens = max_tokens,
  }

  local json_payload = vim.json.encode(payload)

  local curl_cmd = {
    "curl",
    "-s",
    "-X",
    "POST",
    config.api_base .. "/chat/completions",
    "-H",
    "Authorization: Bearer " .. api_key,
    "-H",
    "Content-Type: application/json",
    "-d",
    json_payload,
  }

  local result = vim.fn.system(curl_cmd)
  local exit_code = vim.v.shell_error

  if exit_code ~= 0 then
    return nil, "curl failed with exit code " .. exit_code .. ": " .. result
  end

  local ok, response = pcall(vim.json.decode, result)
  if not ok then
    return nil, "Failed to parse JSON response: " .. result
  end

  if response.error then
    return nil, "API error: " .. (response.error.message or vim.inspect(response.error))
  end

  if response.choices and response.choices[1] and response.choices[1].message then
    return response.choices[1].message.content, nil
  end

  return nil, "Unexpected response format: " .. vim.inspect(response)
end
--
-- Single-turn helper (kept for explain/fix/refactor)
function M.ask(prompt, opts)
  opts = opts or {}
  opts.prompt = prompt
  return request(opts)
end

-- Multi-turn helper: send an explicit messages array
function M.chat(messages, opts)
  opts = opts or {}
  opts.messages = messages
  return request(opts)
end

-- Public API: Test connection
function M.test_connection()
  local prompt = "Say 'Hello from ChatLLM in Neovim!' and nothing else."
  local response, err = M.ask(prompt)

  if err then
    vim.notify("ChatLLM Error: " .. err, vim.log.levels.ERROR)
    return false
  end

  vim.notify("ChatLLM Response: " .. response, vim.log.levels.INFO)
  return true
end

-- Public API: Set configuration
function M.setup(opts)
  opts = opts or {}
  for key, value in pairs(opts) do
    if config[key] ~= nil then
      config[key] = value
    end
  end
end

return M

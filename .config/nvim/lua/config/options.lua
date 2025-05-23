-- $XDG_CONFIG_HOME/nvim/lua/config/options.lua

-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local state = require("config.state")
local g = vim.g
local notify = vim.notify
local log_levels = vim.log.levels

-- Configure language providers
local function setup_providers()
  -- Python provider (required)
  if state.is_language_ready("python") then
    local python_provider = state.get_provider_path("python")
    if python_provider then
      g.python3_host_prog = python_provider
      notify("Python provider configured: " .. python_provider, log_levels.INFO)
    else
      notify("Python provider path not found", log_levels.ERROR)
    end
  else
    notify("Python provider not properly configured", log_levels.ERROR)
  end

  -- Node.js provider (optional)
  if state.is_language_ready("node") then
    local node_provider = state.get_provider_path("node")
    if node_provider then
      g.node_host_prog = node_provider
      notify("Node.js provider configured: " .. node_provider, log_levels.INFO)
    else
      notify("Node.js provider path not found", log_levels.WARN)
      g.loaded_node_provider = 0
    end
  else
    -- Don't warn if Node.js isn't installed - it's optional
    g.loaded_node_provider = 0
  end

  -- Go and Rust don't need providers, they use LSP
  -- But we can check if they're ready
  if not state.is_language_ready("go") then
    notify("Go not configured", log_levels.INFO)
  end

  if not state.is_language_ready("rust") then
    notify("Rust not configured", log_levels.INFO)
  end

  -- Disable unused providers
  g.loaded_perl_provider = 0
  g.loaded_ruby_provider = 0
end

-- Check if providers need updating
if state.check_providers() then
  notify("Some language providers need updating. Run :checkhealth provider", log_levels.WARN)
end

-- Initialize providers
setup_providers()

-- LazyVim default options are good for now
-- Keeping commented section for future reference if we need to override anything
--[[ local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true
opt.termguicolors = true
opt.updatetime = 300
--]]

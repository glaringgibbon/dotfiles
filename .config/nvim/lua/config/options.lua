-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- vim.g.python3_host_prog = vim.loop.os_homedir() .. "/projects/venvs/poetry/neovim-GkWJIk93-py3.13/bin/python"
-- $XDG_CONFIG_HOME/nvim/lua/config/options.lua

local state = require("config.state")
--local opt = vim.opt
local g = vim.g
local notify = vim.notify
local log_levels = vim.log.levels
-- I think these are already set in LazyVim, seems redundant at the moment
-- However, may be useful later if there are some options I'd like to override
-- Leave commented out for now
-- General editor options
--opt.number = true
--opt.relativenumber = true
--opt.expandtab = true
--opt.shiftwidth = 4
--opt.tabstop = 4
--opt.smartindent = true
--opt.termguicolors = true
--opt.updatetime = 300

-- Python provider configuration
local python_provider = state.get_provider_path("python")
if python_provider then
  g.python3_host_prog = python_provider
else
  notify("Python provider not configured", log_levels.WARN)
end

-- Node.js provider configuration
local node_provider = state.get_provider_path("node")
if node_provider then
  g.node_host_prog = node_provider
else
  -- Don't warn if Node.js isn't installed - it's optional
  g.loaded_node_provider = 0
end

-- Disable providers we don't use
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

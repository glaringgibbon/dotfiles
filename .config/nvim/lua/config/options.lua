-- $XDG_CONFIG_HOME/nvim/lua/config/options.lua

-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local state = require("config.state")
local g = vim.g

-- Ensure Python provider via UV
local python = state.ensure_python_provider()
if python then
  g.python3_host_prog = python
end

-- Sync when Neovim version updates
state.sync_providers()

-- Disable unused providers
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

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

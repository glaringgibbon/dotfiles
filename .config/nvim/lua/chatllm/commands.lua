-- lua/chatllm/commands.lua
-- TODO (Phase 8): Expand convenience functions to show sub-options
-- <leader>ar should show picker: [readability, speed, performance, etc.]
-- <leader>ae should show picker: [explain, review, document, etc.]
-- Use nested prompt library structure to auto-generate these menus
local prompts = require("chatllm.prompts")
local actions = require("chatllm.actions")
local editor = require("chatllm.editor")

local M = {}

function M.prompt_picker()
  local list = prompts.get_flat_list()
  vim.ui.select(list, {
    prompt = "Select AI Action:",
    format_item = function(item)
      return string.format("[%s] %s", item.category, item.title)
    end,
  }, function(choice)
    if choice then
      actions.run_prompt(choice.id)
    end
  end)
end

function M.prompt_new()
  vim.ui.input({ prompt = "Category (e.g. code, git): " }, function(cat)
    if not cat or cat == "" then
      return
    end
    vim.ui.input({ prompt = "Sub-ID (e.g. review, lint): " }, function(sub)
      if not sub or sub == "" then
        return
      end

      local template = "-- Title: New Prompt\n-- System: You are a senior engineer.\n\nWrite your prompt here..."
      editor.open_prompt_editor("New Prompt: " .. cat .. "." .. sub, template, function(content)
        local library = prompts.load()
        library[cat] = library[cat] or {}

        local title = content:match("%-%- Title: ([^\n]+)") or sub
        local system = content:match("%-%- System: ([^\n]+)") or ""
        local prompt_text = content:gsub("%-%- Title: [^\n]+\n", ""):gsub("%-%- System: [^\n]+\n", ""):gsub("^%s+", "")

        library[cat][sub] = { title = title, system = system, prompt = prompt_text }
        prompts.save(library)
      end)
    end)
  end)
end

function M.prompt_edit()
  local list = prompts.get_flat_list()
  vim.ui.select(list, {
    prompt = "Edit Prompt:",
    format_item = function(item)
      return item.id
    end,
  }, function(choice)
    if not choice then
      return
    end

    local initial = string.format("-- Title: %s\n-- System: %s\n\n%s", choice.title, choice.system or "", choice.prompt)
    editor.open_prompt_editor("Editing: " .. choice.id, initial, function(content)
      local library = prompts.load()
      local cat, sub = choice.id:match("([^%.]+)%.([^%.]+)")

      local title = content:match("%-%- Title: ([^\n]+)") or sub
      local system = content:match("%-%- System: ([^\n]+)") or ""
      local prompt_text = content:gsub("%-%- Title: [^\n]+\n", ""):gsub("%-%- System: [^\n]+\n", ""):gsub("^%s+", "")

      library[cat][sub] = { title = title, system = system, prompt = prompt_text }
      prompts.save(library)
    end)
  end)
end

function M.prompt_delete()
  local list = prompts.get_flat_list()
  vim.ui.select(list, {
    prompt = "Delete Prompt:",
    format_item = function(item)
      return item.id
    end,
  }, function(choice)
    if not choice then
      return
    end
    vim.ui.input({ prompt = "Delete '" .. choice.id .. "'? (yes/no): " }, function(confirm)
      if confirm == "yes" then
        local library = prompts.load()
        local cat, sub = choice.id:match("([^%.]+)%.([^%.]+)")
        if library[cat] then
          library[cat][sub] = nil
        end
        prompts.save(library)
        vim.notify("Deleted " .. choice.id)
      end
    end)
  end)
end

return M

-- lua/chatllm/editor.lua
local M = {}

function M.open_prompt_editor(title, initial_content, on_save)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)

  -- CRITICAL: Set a fake buffer name so :w doesn't complain
  vim.api.nvim_buf_set_name(buf, "chatllm://prompt-editor")

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " " .. title .. " ",
    title_pos = "center",
  })

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(initial_content, "\n"))

  -- Set buffer options
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].buftype = "acwrite" -- CHANGED: acwrite allows BufWriteCmd to work
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.diagnostic.disable(buf)

  -- Override write command
  vim.api.nvim_create_autocmd("BufWriteCmd", {
    buffer = buf,
    callback = function()
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      on_save(table.concat(lines, "\n"))
      vim.bo[buf].modified = false
      vim.notify("Prompt saved to library.", vim.log.levels.INFO)
    end,
  })

  -- q to close
  vim.keymap.set("n", "q", function()
    if not vim.bo[buf].modified then
      vim.api.nvim_win_close(win, true)
    else
      vim.notify("Unsaved changes. Use :wq to save or :q! to discard.", vim.log.levels.WARN)
    end
  end, { buffer = buf })
end

return M

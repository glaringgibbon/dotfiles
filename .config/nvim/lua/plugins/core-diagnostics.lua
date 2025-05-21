-- Require vim modules at the top
local api = vim.api
local fn = vim.fn
local diagnostic = vim.diagnostic
local keymap = vim.keymap
local notify = vim.notify

return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      -- Diagnostic signs
      local signs = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " ",
      }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- Virtual text state
      local virtual_text_active = false

      -- Base diagnostic configuration
      diagnostic.config({
        virtual_text = virtual_text_active,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      -- Utility function to create a window with diagnostics
      local function create_diagnostic_window(diagnostics, title)
        -- Create a new buffer
        local buf = api.nvim_create_buf(false, true)

        -- Set buffer options
        api.nvim_buf_set_option(buf, "buftype", "nofile")
        api.nvim_buf_set_option(buf, "bufhidden", "wipe")
        api.nvim_buf_set_option(buf, "swapfile", false)

        -- Calculate window size and position
        local width = math.min(120, api.nvim_get_option("columns") - 4)
        local height = math.min(20, api.nvim_get_option("lines") - 4)
        local row = math.floor((api.nvim_get_option("lines") - height) / 2)
        local col = math.floor((api.nvim_get_option("columns") - width) / 2)

        -- Create window
        local win = api.nvim_open_win(buf, true, {
          relative = "editor",
          width = width,
          height = height,
          row = row,
          col = col,
          style = "minimal",
          border = "rounded",
          title = title,
          title_pos = "center",
        })

        -- Set window-local keymaps
        keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true })

        return buf, win
      end

      -- Function to display diagnostics sorted by severity
      local function show_diagnostics_by_severity(workspace)
        local diagnostics = workspace and diagnostic.get() or diagnostic.get(0)
        local severity_order = {
          [diagnostic.severity.ERROR] = 1,
          [diagnostic.severity.WARN] = 2,
          [diagnostic.severity.INFO] = 3,
          [diagnostic.severity.HINT] = 4,
        }

        table.sort(diagnostics, function(a, b)
          if severity_order[a.severity] ~= severity_order[b.severity] then
            return severity_order[a.severity] < severity_order[b.severity]
          end
          return a.lnum < b.lnum
        end)

        local lines = {}
        for _, d in ipairs(diagnostics) do
          local filename = workspace and fn.fnamemodify(api.nvim_buf_get_name(d.bufnr), ":~:.") or ""
          local prefix = workspace and filename .. ":" or ""
          local severity = diagnostic.severity[d.severity]
          table.insert(lines, string.format("%s%d:%d: [%s] %s", prefix, d.lnum + 1, d.col + 1, severity, d.message))
        end

        if #lines == 0 then
          notify("No diagnostics found", "info")
          return
        end

        local buf, _ = create_diagnostic_window(
          diagnostics,
          workspace and "Workspace Diagnostics (Severity)" or "Buffer Diagnostics (Severity)"
        )
        api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      end

      -- Function to display diagnostics sorted by source
      local function show_diagnostics_by_source(workspace)
        local diagnostics = workspace and diagnostic.get() or diagnostic.get(0)
        local by_source = {}

        for _, d in ipairs(diagnostics) do
          local source = d.source or "Unknown"
          by_source[source] = by_source[source] or {}
          table.insert(by_source[source], d)
        end

        local lines = {}
        for source, diags in pairs(by_source) do
          table.insert(lines, "=== " .. source .. " ===")
          for _, d in ipairs(diags) do
            local filename = workspace and fn.fnamemodify(api.nvim_buf_get_name(d.bufnr), ":~:.") or ""
            local prefix = workspace and filename .. ":" or ""
            local severity = diagnostic.severity[d.severity]
            table.insert(lines, string.format("%s%d:%d: [%s] %s", prefix, d.lnum + 1, d.col + 1, severity, d.message))
          end
          table.insert(lines, "")
        end

        if #lines == 0 then
          notify("No diagnostics found", "info")
          return
        end

        local buf, _ = create_diagnostic_window(
          diagnostics,
          workspace and "Workspace Diagnostics (Source)" or "Buffer Diagnostics (Source)"
        )
        api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      end

      -- Function to display diagnostics sorted by code
      local function show_diagnostics_by_code(workspace)
        local diagnostics = workspace and diagnostic.get() or diagnostic.get(0)
        local by_code = {}

        for _, d in ipairs(diagnostics) do
          local code = d.code or "No Code"
          by_code[code] = by_code[code] or {}
          table.insert(by_code[code], d)
        end

        local lines = {}
        for code, diags in pairs(by_code) do
          table.insert(lines, "=== " .. code .. " ===")
          for _, d in ipairs(diags) do
            local filename = workspace and fn.fnamemodify(api.nvim_buf_get_name(d.bufnr), ":~:.") or ""
            local prefix = workspace and filename .. ":" or ""
            local severity = diagnostic.severity[d.severity]
            table.insert(lines, string.format("%s%d:%d: [%s] %s", prefix, d.lnum + 1, d.col + 1, severity, d.message))
          end
          table.insert(lines, "")
        end

        if #lines == 0 then
          notify("No diagnostics found", "info")
          return
        end

        local buf, _ = create_diagnostic_window(
          diagnostics,
          workspace and "Workspace Diagnostics (Code)" or "Buffer Diagnostics (Code)"
        )
        api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      end

      -- Toggle virtual text
      local function toggle_virtual_text()
        virtual_text_active = not virtual_text_active
        diagnostic.config({
          virtual_text = virtual_text_active,
        })
        notify("Virtual text " .. (virtual_text_active and "enabled" or "disabled"), "info")
      end

      -- Keymaps
      keymap.set("n", "<leader>xv", toggle_virtual_text, { desc = "Toggle Virtual Text" })
      keymap.set("n", "<leader>xs", function()
        show_diagnostics_by_severity(false)
      end, { desc = "Buffer Diagnostics (Severity)" })
      keymap.set("n", "<leader>xS", function()
        show_diagnostics_by_severity(true)
      end, { desc = "Workspace Diagnostics (Severity)" })
      keymap.set("n", "<leader>xo", function()
        show_diagnostics_by_source(false)
      end, { desc = "Buffer Diagnostics (Source)" })
      keymap.set("n", "<leader>xO", function()
        show_diagnostics_by_source(true)
      end, { desc = "Workspace Diagnostics (Source)" })
      keymap.set("n", "<leader>xc", function()
        show_diagnostics_by_code(false)
      end, { desc = "Buffer Diagnostics (Code)" })
      keymap.set("n", "<leader>xC", function()
        show_diagnostics_by_code(true)
      end, { desc = "Workspace Diagnostics (Code)" })
    end,
  },
}

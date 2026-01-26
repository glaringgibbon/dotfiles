return {
  "gruvw/strudel.nvim",
  url = "git@github.com:gruvw/strudel.nvim.git",
  build = "npm ci",
  opts = {
    -- UI options
    ui = {
      maximise_menu_panel = true, -- Side-by-side workflow
      hide_menu_panel = false,
      hide_top_bar = false,
      hide_code_editor = false,
      hide_error_display = false,
    },
    start_on_launch = true, -- Auto-play when launching
    update_on_save = false, -- Set true if you want auto-eval on save
    sync_cursor = true, -- Two-way cursor sync
    report_eval_errors = true, -- Show errors in Neovim
    headless = false, -- Set true for no browser window
    browser_data_dir = "~/.cache/strudel-nvim/",
  },
  config = function(_, opts)
    local strudel = require("strudel")
    strudel.setup(opts)

    -- Keybinds using 'z' prefix (avoiding 's' for search)
    vim.keymap.set("n", "<leader>zl", strudel.launch, { desc = "Strudel: Launch" })
    vim.keymap.set("n", "<leader>zq", strudel.quit, { desc = "Strudel: Quit" })
    vim.keymap.set("n", "<leader>zt", strudel.toggle, { desc = "Strudel: Toggle Play/Stop" })
    vim.keymap.set("n", "<leader>zu", strudel.update, { desc = "Strudel: Update (Eval)" })
    vim.keymap.set("n", "<leader>zs", strudel.stop, { desc = "Strudel: Stop Playback" })
    vim.keymap.set("n", "<leader>zb", strudel.set_buffer, { desc = "Strudel: Set Buffer" })
    vim.keymap.set("n", "<leader>zx", strudel.execute, { desc = "Strudel: Execute (Set + Update)" })
  end,
}

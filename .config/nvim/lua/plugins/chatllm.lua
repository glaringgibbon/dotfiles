-- lua/plugins/chatllm.lua
return {
  "chatllm",
  dir = vim.fn.stdpath("config") .. "/lua/chatllm",
  virtual = true,
  keys = {
    {
      "<leader>ac",
      function()
        require("chatllm.actions").chat()
      end,
      desc = "AI Chat",
    },
    {
      "<leader>at",
      function()
        require("chatllm.ui").toggle_window()
      end,
      desc = "AI Toggle Window",
    },
    {
      "<leader>ae",
      function()
        require("chatllm.actions").explain()
      end,
      mode = { "n", "v" },
      desc = "AI Explain",
    },
    {
      "<leader>af",
      function()
        require("chatllm.actions").fix()
      end,
      mode = { "n", "v" },
      desc = "AI Fix/Optimize",
    },
    {
      "<leader>ar",
      function()
        require("chatllm.actions").refactor()
      end,
      mode = { "n", "v" },
      desc = "AI Refactor",
    },
    {
      "<leader>ax",
      function()
        require("chatllm.ui").clear()
      end,
      desc = "AI Clear History",
    },
    {
      "<leader>am",
      function()
        require("chatllm.models").pick_model()
      end,
      desc = "AI Select Model",
    },

    -- NEW: Prompt management
    {
      "<leader>apa",
      function()
        require("chatllm.commands").prompt_picker()
      end,
      mode = { "n", "v" },
      desc = "AI Pick Prompt",
    },
    {
      "<leader>apn",
      function()
        require("chatllm.commands").prompt_new()
      end,
      desc = "AI New Prompt",
    },
    {
      "<leader>ape",
      function()
        require("chatllm.commands").prompt_edit()
      end,
      desc = "AI Edit Prompt",
    },
    {
      "<leader>apd",
      function()
        require("chatllm.commands").prompt_delete()
      end,
      desc = "AI Delete Prompt",
    },
  },
}

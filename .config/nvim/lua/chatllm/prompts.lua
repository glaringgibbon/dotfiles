-- lua/chatllm/prompts.lua
local M = {}

local function get_data_dir()
  local xdg_data = os.getenv("XDG_DATA_HOME") or (os.getenv("HOME") .. "/.local/share")
  return xdg_data .. "/chatllm"
end

local function get_prompts_file()
  return get_data_dir() .. "/prompts.lua"
end

-- Default Library (Nested Categories)
local function get_default_library()
  return {
    code = {
      explain = {
        title = "Explain Code",
        system = "You are a senior software engineer specializing in clear technical communication.",
        prompt = "Explain the following code. Focus on logic, edge cases, and architectural choices:\n\n",
      },
      review = {
        title = "Review Code (Issues Only)",
        system = "You are a pedantic and thorough code reviewer.",
        prompt = "Identify bugs, security flaws, and anti-patterns. Do NOT provide fixes yet, just a list of issues:\n\n",
      },
      patch = {
        title = "Fix Code (Solutions)",
        system = "You are a senior software engineer specializing in bug fixes and optimization.",
        prompt = "Provide a corrected and optimized version of the following code. Explain the changes:\n\n",
        -- TODO (Phase 7): Implement context injection UI for prompt chaining
        context = {
          accepts = true,
          hint = "Paste output from 'Review Code' for targeted fixes",
          template = "Review findings:\n\n{{context}}\n\nCode to fix:\n\n{{code}}",
        },
      },
    },
    refactor = {
      readability = {
        title = "Refactor for Readability",
        system = "You are an expert in Clean Code and software craftsmanship.",
        prompt = "Refactor this code to be as readable and simple as possible:\n\n",
      },
    },
    git = {
      commit = {
        title = "Generate Commit Message",
        system = "You follow the Conventional Commits standard.",
        prompt = "Write a clear commit message for the following changes:\n\n",
      },
    },
  }
end

function M.load()
  local file = get_prompts_file()
  if vim.fn.filereadable(file) == 1 then
    local ok, user_prompts = pcall(dofile, file)
    if ok and type(user_prompts) == "table" then
      return user_prompts
    end
  end
  local defaults = get_default_library()
  M.save(defaults)
  return defaults
end

function M.save(library)
  local dir = get_data_dir()
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
  local content = "return " .. vim.inspect(library)
  local file = io.open(get_prompts_file(), "w")
  if file then
    file:write(content)
    file:close()
  end
end

function M.get_flat_list()
  local library = M.load()
  local flat = {}
  for cat_id, sub_cats in pairs(library) do
    for sub_id, data in pairs(sub_cats) do
      table.insert(flat, {
        id = cat_id .. "." .. sub_id,
        category = cat_id,
        sub_id = sub_id,
        title = data.title or sub_id,
        system = data.system,
        prompt = data.prompt,
      })
    end
  end
  table.sort(flat, function(a, b)
    return a.id < b.id
  end)
  return flat
end

function M.get_by_id(full_id)
  local cat, sub = full_id:match("([^%.]+)%.([^%.]+)")
  if not cat or not sub then
    return nil
  end
  local library = M.load()
  return library[cat] and library[cat][sub]
end

return M

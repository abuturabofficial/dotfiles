-- ~/.config/nvim/lua/plugins/img-clip.lua

local wiki_repo = vim.fn.expand("~/Documents/git/w3/w3-wiki") -- no trailing slash
local wiki_static = wiki_repo .. "/static/notes"

-- ImageMagick 7 uses "magick", older versions use "convert"
local im = vim.fn.executable("magick") == 1 and "magick" or "convert"

-- first free "<base>-<n>" name inside dir
local function next_name(dir, base)
  local n = 1
  while vim.uv.fs_stat(string.format("%s/%s-%d.webp", dir, base, n)) do
    n = n + 1
  end
  return base .. "-" .. n
end

local function paste_image()
  local file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p")
  local dir = vim.fn.fnamemodify(file, ":h")
  local opts

  if vim.startswith(file, wiki_repo .. "/") then
    -- WIKI: static/notes/<course>/<name>-N.webp, link /notes/<course>/<name>-N.webp
    local base = vim.fn.fnamemodify(file, ":t:r")
    local course = vim.fn.fnamemodify(dir, ":t")
    local target = wiki_static .. "/" .. course
    opts = {
      dir_path = target,
      file_name = next_name(target, base),
      template = "![](/notes/" .. course .. "/$FILE_NAME)",
    }
  else
    -- BLOG: <blog-name>/<blog-name>-N.webp, link <blog-name>-N.webp
    local base = vim.fn.fnamemodify(dir, ":t")
    opts = {
      dir_path = dir,
      file_name = next_name(dir, base),
      template = "![]($FILE_NAME)",
    }
  end

  require("img-clip").paste_image(opts)
end

return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    default = {
      relative_to_current_file = false,
      prompt_for_file_name = false,
      extension = "webp",
      process_cmd = im .. " - -quality 75 webp:-",
    },
  },
  keys = {
    { "<leader>pp", paste_image, desc = "Paste image (auto: wiki/blog)" },
  },
}

-- Customize Treesitter
-- Note: Main treesitter config moved to astrocore.lua for v6
-- Treesitter: enabled on WSL/Linux, conditional on Windows (needs cl.exe or zig)

local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1

-- Function to find MSVC compiler (VS 2022/2026 Professional only)
local function find_msvc_compiler()
  if vim.fn.executable("cl") == 1 then
    return nil -- Already in PATH
  end

  -- Visual Studio 2022 or 2026 Professional only
  local vs_versions = { "2026", "2022" }
  local base_path = "C:/Program Files/Microsoft Visual Studio"

  for _, version in ipairs(vs_versions) do
    local msvc_base = base_path .. "/" .. version .. "/Professional/VC/Tools/MSVC"
    if vim.fn.isdirectory(msvc_base) == 1 then
      -- Find latest MSVC toolchain version
      local versions = vim.fn.globpath(msvc_base, "*", false, true)
      if #versions > 0 then
        table.sort(versions)
        local latest_version = versions[#versions]
        -- Check for compiler in multiple host/target combinations
        local bin_paths = {
          latest_version .. "/bin/Hostx64/x64",
          latest_version .. "/bin/Hostx86/x86",
          latest_version .. "/bin/Hostx64/x86",
        }
        for _, bin_path in ipairs(bin_paths) do
          if vim.fn.filereadable(bin_path .. "/cl.exe") == 1 then
            return bin_path
          end
        end
      end
    end
  end

  return nil
end

local msvc_path = find_msvc_compiler()
local has_compiler = vim.fn.executable("cl") == 1 or vim.fn.executable("zig") == 1 or vim.fn.executable("gcc") == 1 or msvc_path ~= nil

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  enabled = not is_windows or has_compiler, -- Enable if not Windows OR has compiler
  opts = {
    -- Additional parser-specific overrides
    highlight = {
      enable = not is_windows or has_compiler,
      -- disable treesitter for large files
      disable = function(lang, bufnr)
        return vim.api.nvim_buf_line_count(bufnr) > 10000 and (lang == "cpp" or lang == "c" or lang == "csv")
      end,
      additional_vim_regex_highlighting = false,
    },
    -- Disable auto-install on Windows to prevent issues
    auto_install = not is_windows,
  },
  build = ":TSUpdate",
  init = function()
    -- Configure MSVC compiler on Windows before plugin loads
    if is_windows and msvc_path then
      -- Add MSVC to PATH if not already there
      if vim.fn.executable("cl") == 0 then
        local current_path = vim.env.PATH or os.getenv("PATH") or ""
        if current_path ~= "" then
          vim.env.PATH = msvc_path .. ";" .. current_path
        else
          vim.env.PATH = msvc_path
        end
      end
    end
  end,
  config = function(plugin, opts)
    -- Set compiler preference after plugin loads
    if is_windows and (vim.fn.executable("cl") == 1 or msvc_path) then
      require("nvim-treesitter.install").compilers = { "cl" }
    end
    -- Don't call setup here - it's handled by astrocore.lua
  end,
}

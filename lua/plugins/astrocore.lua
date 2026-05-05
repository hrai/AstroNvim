-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Treesitter configuration (v6: moved from plugins to astrocore)
    -- Conditional: full support on WSL/Linux, conditional on Windows (requires compiler)
    treesitter = (function()
      local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1

      -- Function to check for MSVC compiler
      local function has_msvc()
        local vs_versions = { "2026", "2022" }
        local base_path = "C:/Program Files/Microsoft Visual Studio"
        for _, version in ipairs(vs_versions) do
          local msvc_base = base_path .. "/" .. version .. "/Professional/VC/Tools/MSVC"
          if vim.fn.isdirectory(msvc_base) == 1 then
            local versions = vim.fn.globpath(msvc_base, "*", false, true)
            if #versions > 0 then
              return true
            end
          end
        end
        return false
      end

      local has_compiler = vim.fn.executable("cl") == 1 or vim.fn.executable("zig") == 1 or vim.fn.executable("gcc") == 1 or has_msvc()

      if is_windows and not has_compiler then
        -- Windows without compiler: disable treesitter, use Vim syntax
        return {
          ensure_installed = {},
          auto_install = false,
          highlight = false,
        }
      else
        -- WSL/Linux OR Windows with compiler: full treesitter support
        return {
          ensure_installed = is_windows and {} or { "vim", "lua", "comment", "markdown_inline", "regex", "python" },
          auto_install = not is_windows, -- Disable auto-install on Windows
          highlight = true,
          textobjects = {
            select = {
              enable = not is_windows, -- Disable textobjects on Windows until parsers are manually installed
              lookahead = true,
              keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
              },
              selection_modes = {
                ["@parameter.outer"] = "v",
                ["@function.outer"] = "V",
                ["@class.outer"] = "<c-v>",
              },
              include_surrounding_whitespace = true,
            },
          },
        }
      end
    end)(),
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },
    },
  },
}

return {
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "marko-cerovac/material.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function(_, opts)
      vim.g.material_style = "deep ocean"
      require("material").setup(opts)
      vim.cmd "colorscheme material"
    end,
  }, --colorscheme
  { "Pocco81/auto-save.nvim" },
  { "tpope/vim-abolish" },
  { "tpope/vim-repeat" },
  { "tpope/vim-surround", keys = { "c", "d", "y" } },
  -- { "kshenoy/vim-signature",         keys = { "m" } }, -- mx - Toggle mark 'x' and display it in the leftmost column
  { "godlygeek/tabular" },
  { "preservim/vim-markdown", name = "vim-markdown", ft = "md" },
  { "tpope/vim-markdown", name = "tpope-markdown", ft = "md" },
  { "tpope/vim-fugitive" },
  -- { "tpope/vim-rhubarb" },
  { "christoomey/vim-tmux-navigator" },
  { "editorconfig/editorconfig-vim" },
  { "ggandor/lightspeed.nvim" },
  { "mg979/vim-visual-multi" },
  { "elzr/vim-json", ft = "json" },
  { "justinmk/vim-gtfo" }, --Go to Terminal or File manager
  { "chrisbra/csv.vim", ft = "csv" },
  { "psliwka/vim-smoothie" }, --Smooth scrolling
  { "lambdalisue/suda.vim" },
  { "Almo7aya/openingh.nvim" },
  {
    "linrongbin16/gitlinker.nvim",
    cmd = "GitLink",
    opts = {},
    keys = {
      { "<leader>gy", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Yank git permalink" },
      { "<leader>gY", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git permalink" },
    },
    -- config = function()
    --   vim.cmd([[
    --     " command! Gblame :GitLink!<cr>
    --   ]])
    -- end,
  },
  {
    "panozzaj/vim-autocorrect",
    config = function()
      vim.cmd [[
        autocmd filetype * call AutoCorrect()
        ]]
    end,
  },
  {
    "ethanholz/nvim-lastplace", --Return to last edit position when opening files (You want this!)
    config = function() require("nvim-lastplace").setup {} end,
  },
  { "monaqa/dial.nvim" },
  { -- override blink.cmp plugin
    "Saghen/blink.cmp",
    dependencies = {
      {
        "Kaiser-Yang/blink-cmp-dictionary",
        dependencies = { "nvim-lua/plenary.nvim" },
        -- "mikavilpas/blink-ripgrep.nvim",
      },
      -- ... Other dependencies
    },
    opts = {
      sources = {
        providers = {
          path = { score_offset = 1 },
          lsp = { score_offset = 4 },
          snippets = { score_offset = -1 },
          buffer = { score_offset = 2 },
          -- ripgrep = { score_offset = 0 },
          dictionary = {
            score_offset = 3,
            module = "blink-cmp-dictionary",
            name = "Dict",
            -- Make sure this is at least 2.
            -- 3 is recommended
            min_keyword_length = 3,
            opts = {
              -- options for blink-cmp-dictionary
            },
          },
        },
      },
      completion = {
        menu = {
          draw = {
            columns = {
              { "kind_icon", "label", "label_description", gap = 1 },
              { "kind", "source_name", gap = 1 },
            },
          },
        },
      },
    },
  },
  {
    "monkoose/neocodeium",
    event = "VeryLazy",
    config = function()
      local neocodeium = require "neocodeium"
      neocodeium.setup()
      -- set up some sort of keymap to cycle and complete to trigger completion
      -- vim.keymap.del("i", "<A-e>")
      vim.keymap.set("i", "<A-n>", function() neocodeium.cycle_or_complete() end, { silent = true, noremap = true })
      -- make sure to have a mapping to accept a completion
      vim.keymap.set("i", "<Right>", function() neocodeium.accept() end, { silent = true, noremap = true })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "comment", "markdown_inline", "regex", "python" },
      auto_install = true,
      highlight = {
        enable = false,
      },
      indent = {
        enable = false,
      },
    },
  },
  {
    "lukas-reineke/headlines.nvim", --This plugin adds horizontal highlights for text filetypes, like markdown, orgmode, and neorg
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true, -- or `opts = {}`
  },
  {
    "AckslD/nvim-neoclip.lua", --Clipboard manager neovim plugin with telescope integration
    dependencies = {
      { "kkharji/sqlite.lua", module = "sqlite" },
      { "nvim-telescope/telescope.nvim" },
    },
    after = "telescope",
    config = function() require("neoclip").setup { default_register = { '"', "+", "*" } } end,
  },
  {
    "airblade/vim-rooter",
    after = "telescope",
    config = function()
      vim.cmd [[
              let g:rooter_patterns = ['.git', '.svn', 'package.json', '!node_modules']
              let g:rooter_silent_chdir = 1
              let g:rooter_change_directory_for_non_project_files = 'current' "Change to file's directory (similar to autochdir).
              ]]
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    "kiyoon/treesitter-indent-object.nvim",
    keys = {
      {
        "ai",
        "<Cmd>lua require'treesitter_indent_object.textobj'.select_indent_outer()<CR>",
        mode = { "x", "o" },
        desc = "Select context-aware indent (outer)",
      },
      {
        "aI",
        "<Cmd>lua require'treesitter_indent_object.textobj'.select_indent_outer(true)<CR>",
        mode = { "x", "o" },
        desc = "Select context-aware indent (outer, line-wise)",
      },
      {
        "ii",
        "<Cmd>lua require'treesitter_indent_object.textobj'.select_indent_inner()<CR>",
        mode = { "x", "o" },
        desc = "Select context-aware indent (inner, partial range)",
      },
      {
        "iI",
        "<Cmd>lua require'treesitter_indent_object.textobj'.select_indent_inner(true)<CR>",
        mode = { "x", "o" },
        desc = "Select context-aware indent (inner, entire range)",
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
    opts = function(_, opts)
      local null_ls = require "null-ls"

      -- opts.debug = true
      opts.sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettierd.with {
          filetypes = {
            "css",
            "scss",
            "less",
            "html",
            "json",
            "yaml",
            "markdown",
            "graphql",
          },
        },
        require "none-ls.diagnostics.eslint_d",
        null_ls.builtins.completion.spell,
      }
      return opts
    end,
  },
  {
    "folke/which-key.nvim",
    enabled = false, --disable/Disabling Plugins
    -- opts = function(_, opts)
    -- opts.ignore_missing = true --hide any mapping for which you didn't explicitly defined a label
    -- return opts
    -- end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    init = function()
      -- global
      vim.api.nvim_set_keymap("n", "<leader>e", ":Neotree<cr>", { silent = true, noremap = true })
    end,
  },
  {
    "mbbill/undotree",
    init = function() vim.api.nvim_set_keymap("n", "<F5>", ":UndotreeToggle<cr>", { silent = true, noremap = true }) end,
  },
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = table.concat({
            " █████  ███████ ████████ ██████   ██████ ",
            "██   ██ ██         ██    ██   ██ ██    ██",
            "███████ ███████    ██    ██████  ██    ██",
            "██   ██      ██    ██    ██   ██ ██    ██",
            "██   ██ ███████    ██    ██   ██  ██████ ",
            "",
            "███    ██ ██    ██ ██ ███    ███",
            "████   ██ ██    ██ ██ ████  ████",
            "██ ██  ██ ██    ██ ██ ██ ████ ██",
            "██  ██ ██  ██  ██  ██ ██  ██  ██",
            "██   ████   ████   ██ ██      ██",
          }, "\n"),

          keys = {
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
    },
  },
  -- {
  --   "nvim-tree/nvim-tree.lua",
  --   version = "*",
  --   lazy = false,
  --   dependencies = {
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   config = function()
  --     require("nvim-tree").setup {
  --       view = { relativenumber = true },
  --       -- sync_root_with_cwd=true,
  --       actions = {
  --           change_dir = {
  --               enable = true,
  --               -- global = true,
  --           },
  --       },
  --     }
  --   end,
  --   init = function()
  --     -- global
  --     vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<cr>", { silent = true, noremap = true })
  --
  --     -- autoclose if last buffer
  --     vim.api.nvim_create_autocmd("BufEnter", {
  --       group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
  --       pattern = "NvimTree_*",
  --       callback = function()
  --         local layout = vim.api.nvim_call_function("winlayout", {})
  --         if
  --           layout[1] == "leaf"
  --           and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree"
  --           and layout[3] == nil
  --         then
  --           vim.cmd "confirm quit"
  --         end
  --       end,
  --     })
  --   end,
  -- },
  {
    "jvgrootveld/telescope-zoxide",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
    },
    after = "telescope",
    config = function()
      require("telescope").load_extension "zoxide"
      vim.keymap.set("n", "<leader>cd", require("telescope").extensions.zoxide.list)
    end,
  },
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    init = function() vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" }) end,
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "OXY2DEV/markview.nvim",
    ft = "markdown", -- If you decide to lazy-load anyway
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
  -- { "rebelot/heirline.nvim", enabled = false },
}

--[[
if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

---@type LazySpec
return {

  -- == Examples of Adding Plugins ==

  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- == Examples of Overriding Plugins ==

  -- customize dashboard options
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = table.concat({
            " █████  ███████ ████████ ██████   ██████ ",
            "██   ██ ██         ██    ██   ██ ██    ██",
            "███████ ███████    ██    ██████  ██    ██",
            "██   ██      ██    ██    ██   ██ ██    ██",
            "██   ██ ███████    ██    ██   ██  ██████ ",
            "",
            "███    ██ ██    ██ ██ ███    ███",
            "████   ██ ██    ██ ██ ████  ████",
            "██ ██  ██ ██    ██ ██ ██ ████ ██",
            "██  ██ ██  ██  ██  ██ ██  ██  ██",
            "██   ████   ████   ██ ██      ██",
          }, "\n"),
        },
      },
    },
  },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
}
--]]

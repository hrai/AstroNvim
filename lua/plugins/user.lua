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
  { "uga-rosa/cmp-dictionary", dependencies = { "hrsh7th/nvim-cmp" } },
  { "monaqa/dial.nvim" },
  -- add this to the file where you setup your other plugins:
  {
    "hrsh7th/nvim-cmp",
    -- dependencies = "tzachar/cmp-tabnine",
    opts = function(_, opts)
      local cmp = require "cmp"

      opts.sources = cmp.config.sources {
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip", priority = 900 },
        { name = "buffer", priority = 800 },
        { name = "path", priority = 700 },
        { name = "emoji", priority = 650 },
      }
      opts.completion = {
        completeopt = "menu,menuone,noinsert",
      }

      return opts
    end,
  },
  {
    "monkoose/neocodeium",
    event = "VeryLazy",
    config = function()
      local cmp = require "cmp"
      local neocodeium = require "neocodeium"

      cmp.event:on("menu_opened", function() neocodeium.clear() end)

      neocodeium.setup {
        filter = function() return not cmp.visible() end,
      }

      cmp.setup {
        completion = {
          autocomplete = false,
        },
      }
      -- neocodeium.setup {
      --   manual = true, -- recommended to not conflict with nvim-cmp
      -- }

      --   -- create an autocommand which closes cmp when ai completions are displayed
      --   vim.api.nvim_create_autocmd("User", {
      --     pattern = "NeoCodeiumCompletionDisplayed",
      --     callback = function() require("cmp").abort() end,
      --   })

      -- set up some sort of keymap to cycle and complete to trigger completion
      -- vim.keymap.del("i", "<A-e>")
      vim.keymap.set("i", "<A-n>", function() neocodeium.cycle_or_complete() end, { silent = true, noremap = true })
      -- make sure to have a mapping to accept a completion
      vim.keymap.set("i", "<Right>", function() neocodeium.accept() end, { silent = true, noremap = true })
    end,
  },

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
    "goolord/alpha-nvim",
    opts = function(_, opts)
      -- customize the dashboard header
      opts.section.header.val = {
        " █████  ███████ ████████ ██████   ██████",
        "██   ██ ██         ██    ██   ██ ██    ██",
        "███████ ███████    ██    ██████  ██    ██",
        "██   ██      ██    ██    ██   ██ ██    ██",
        "██   ██ ███████    ██    ██   ██  ██████",
        " ",
        "    ███    ██ ██    ██ ██ ███    ███",
        "    ████   ██ ██    ██ ██ ████  ████",
        "    ██ ██  ██ ██    ██ ██ ██ ████ ██",
        "    ██  ██ ██  ██  ██  ██ ██  ██  ██",
        "    ██   ████   ████   ██ ██      ██",
      }
      opts.section.buttons.val = {
        opts.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
        opts.button("f", "  > Find file", ":Telescope find_files<CR>"),
        opts.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
        opts.button("c", "  > Config/Settings", ":e $MYVIMRC<CR>"),
        opts.button("p", "  > Plugins Config/Settings", ":e $MYVIMPLUGINS<CR>"),
        -- opts.button("c", "  > Config/Settings", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
        opts.button("q", "  > Quit NVIM", ":qa<CR>"),
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


local function get_tabnine_build_string()
  if vim.fn.has("win32") == 1 then
    -- use special windows path
    return "pwsh.exe -file .\\install.ps1"
  else
    -- unix path
    return "./install.sh"
  end
end

return {
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  { "marko-cerovac/material.nvim" ,
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function(_, opts)
        vim.g.material_style = "deep ocean"
        require("material").setup(opts)
        vim.cmd 'colorscheme material'
    end,
  }, --colorscheme
  { "Pocco81/auto-save.nvim" },
  { "tpope/vim-abolish" },
  { "tpope/vim-repeat" },
  { "tpope/vim-surround",            keys = { "c", "d", "y" } },
  -- { "kshenoy/vim-signature",         keys = { "m" } }, -- mx - Toggle mark 'x' and display it in the leftmost column
  { "godlygeek/tabular" },
  { "preservim/vim-markdown",        name = "vim-markdown",   ft = "md" },
  { "tpope/vim-markdown",            name = "tpope-markdown", ft = "md" },
  { "tpope/vim-fugitive" },
  -- { "tpope/vim-rhubarb" },
  { "christoomey/vim-tmux-navigator" },
  { "editorconfig/editorconfig-vim" },
  { "ggandor/lightspeed.nvim" },
  { "mg979/vim-visual-multi" },
  { "elzr/vim-json",                 ft = "json" },
  { "justinmk/vim-gtfo" },    --Go to Terminal or File manager
  { "chrisbra/csv.vim",              ft = "csv" },
  { "psliwka/vim-smoothie" }, --Smooth scrolling
  { "lambdalisue/suda.vim" },
  { "Almo7aya/openingh.nvim" },
  {
    "linrongbin16/gitlinker.nvim",
    cmd = "GitLink",
    opts = {},
    keys = {
      { "<leader>gy", "<cmd>GitLink<cr>",  mode = { "n", "v" }, desc = "Yank git permalink" },
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
      vim.cmd([[
        autocmd filetype * call AutoCorrect()
      ]])
    end,
  },
  {
    "ethanholz/nvim-lastplace", --Return to last edit position when opening files (You want this!)
    config = function()
      require("nvim-lastplace").setup({})
    end,
  },
  { "uga-rosa/cmp-dictionary", dependencies = { "hrsh7th/nvim-cmp" } },
  { "monaqa/dial.nvim" },
  {
    "tzachar/cmp-tabnine",
    after = "nvim-cmp",
    -- build = function()
    --     if jit.os == "Linux" then
    --         print("Executing install.sh...")
    --         vim.cmd [[execute ":! ~/.local/share/lunarvim/site/pack/lazy/opt/cmp-tabnine/install.sh"]]
    --     else
    --         print("Executing install.ps1...")
    --         EXECUTE BELOW...
    --         pwsh "$HOME\AppData\Roaming\lunarvim\site\pack\lazy\opt\cmp-tabnine\install.ps1"
    --         vim.cmd [[execute ":! pwsh -File $HOME\\AppData\\Roaming\\lunarvim\\site\\pack\\packer\\start\\cmp-tabnine\\install.ps1"]]
    --         -- vim.cmd [[execute ":! pwsh -Command pwd"]]
    --         print("Executed install.ps1...")
    --     end
    -- end,
    build = get_tabnine_build_string(),
    dependencies = "hrsh7th/nvim-cmp",
  },
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {"comment", "markdown_inline", "regex", "python" },
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
      { "kkharji/sqlite.lua",           module = "sqlite" },
      { "nvim-telescope/telescope.nvim" },
    },
    after = "telescope",
    config = function()
      require("neoclip").setup({ default_register = { '"', "+", "*" } })
    end,
  },
  {
    "airblade/vim-rooter",
    after = "telescope",
    config = function()
      vim.cmd([[
              let g:rooter_patterns = ['.git', '.svn', 'package.json', '!node_modules']
            ]])
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
        }
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
  }
}

--[[
if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- You can also add or configure plugins by creating files in this `plugins/` folder
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

  -- customize alpha options
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
      return opts
    end,
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
]]--

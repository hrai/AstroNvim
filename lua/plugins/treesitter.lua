-- Customize Treesitter
-- Note: Main treesitter config moved to astrocore.lua for v6

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  -- In v6, nvim-treesitter is just a parser download utility
  -- All configuration is in astrocore.lua, not here
  init = function()
    -- Configure treesitter compiler for Linux/WSL
    require("nvim-treesitter.install").prefer_git = true
    require("nvim-treesitter.install").compilers = { "gcc", "clang" }
  end,
}

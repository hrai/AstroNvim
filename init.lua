-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.

vim.g.mapleader = "," --without this, the which-key breaks

----------------------- ASTRO NVIM CONFIG -------------------------------------
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

require "lazy_setup"
require "polish"

----------------------- ASTRO NVIM CONFIG ENDS -------------------------------------

-- vim options
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.relativenumber = true

vim.cmd [[

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set nowb
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Default directory settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("win32") " || expand("%:p:h") =~ 'mnt'
    let g:vim_folder=expand("~/AppData/Local/nvim/")
else
    let g:vim_folder=expand("~/.config/nvim/")
endif

set backup
if !isdirectory(g:vim_folder)
    silent! execute "!mkdir " . g:vim_folder > /dev/null 2>&1
endif

let &backupdir=g:vim_folder . 'temp_dirs/undodir'
let &directory=g:vim_folder . 'temp_dirs/undodir'
let &undodir=g:vim_folder . 'temp_dirs/undodir'
]]

vim.cmd [[

nmap <C-s> :w<cr>

nmap <Tab> :bnext<CR>
nmap <S-Tab> :bprevious<CR>

au BufReadPost *.notes set filetype=txt
autocmd BufEnter * if &filetype == "" | setlocal ft=text | endif

"change working directory to current opened file
" autocmd VimEnter * set autochdir "Doesn't work due to vim-rooter

" Tmux auto dir change
autocmd DirChanged * call chansend(v:stderr, printf("\033]7;file://%s\033\\", v:event.cwd))
autocmd VimLeave * call chansend(v:stderr, "\033]7;\033\\")

function! CleanWindowsLineBreak()
  " :LvimUpdate
  :%s/\r//g
endfunction
command! CleanWindowsLineBreak call CleanWindowsLineBreak()

function! UpdateVim()
  " :LvimUpdate
  :Lazy sync
endfunction
nmap <leader>pu :call UpdateVim()<cr>

" disable folding of sections like JS functions
set foldmethod=indent       " manual fold
set foldnestmax=3           " deepest fold is 3 levels
set nofoldenable            " don't fold by default

set wrap

set scrolloff=2

""""""""""""""""""""""""""""""
" => notes section
""""""""""""""""""""""""""""""

autocmd FileType notes :setlocal spell

" automatically uppercase the first letter of the sentence
augroup AUTOCAPITALISE
  au!
  autocmd InsertCharPre *.notes,*.txt,*.md if search('\v(^|[-.!?:]\_s)\_s*%#', 'bcnw') != 0 | let v:char = toupper(v:char) | endif
augroup END

autocmd VimLeavePre *.notes call GitCommitPush('cleanup')

]]

vim.cmd [[
nnoremap <space> :

" Smart way to move between windows
" map <C-j> <C-W>j
" map <C-k> <C-W>k
" map <C-h> <C-W>h
" map <C-l> <C-W>l

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
nmap <leader>tn :tabnew<cr>

" Switch CWD to the directory of the open buffer
" map <leader>cd :cd %:p:h<cr>:pwd<cr>

command! BufOnly silent! execute "%bd|e#|bd#"
map <leader>bo BufOnly

" Switch to home directory
map <leader>ch :cd ~<cr>

nmap <leader>ro :e ~/.nb/home/rough.notes<cr>

" Copies current buffer into a new tab
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg

"Closing/saving files
nnoremap <leader>x :x!<CR>
nnoremap <leader>q :q!<CR>

"Map go to declaration for ctags
noremap <F12> <C-]>

"Repeat last Ex mode command
nnoremap \ @:
vnoremap \ @:

"Delete all the content of the file/buffer
nnoremap daf :%d<CR>

" Increase/decrease numbers
nnoremap <A-a> <C-a>
nnoremap <A-x> <C-x>

"Indentation
nnoremap > >>
nnoremap < <<

"Copying the word under cursor to clipboard
nnoremap <C-C> viw"+y

"Select all
nnoremap <C-A> ggVG

"Yanking the file contents to clipboard
nnoremap <F6> gg"+yG

"Putting from clipboard
noremap <C-P> "+p
inoremap <C-P> <C-R>+
cnoremap <C-P> <C-R>+<space>

" => Add linebreak without entering insert mode
nnoremap <F9> o<Esc>
nnoremap <F8> O<Esc>

" Opening files
command! Vconf :e ~/.vimrc
command! Zc :e ~/.zshrc
command! Gconf :e ~/.gitconfig
command! Gignore :e ~/.gitignore
command! Bconf :e ~/.bashrc
command! Tconf :e ~/.tmux.conf
]]

vim.cmd [[
" This section contains custom methods

function! Push_Config()
  if has("win32")
    exec ":! push_lvim_config"
  else
    exec ":! source ~/.bashrc; push_lvim_config"
  endif
endfunction

function! Pull_Config()
  if has("win32")
    exec ":! pull_lvim_config"
  else
    exec ":! source ~/.bashrc; pull_lvim_config"
  endif
endfunction

nmap cpl :call Pull_Config()<CR>
nmap cps :call Push_Config()<CR>

function! GitCommitPush(commit_message)
  Gw
  exec "Git commit -m \"". a:commit_message. "\""
  Git push
endfunction

command! -nargs=1 Gap call GitCommitPush(<f-args>)

nnoremap gap :Gap<space>
nnoremap gcl :Gap cleanup<CR>
nnoremap gnw :Gap new words<CR>


function! ModifyInsideBrackets(commandType) abort
    let curr_line=getline('.')
    let cursor_pos=col('.')

    let brackets = ["[", "]", "(", ")", "{", "}", "\"", "'", "<", ">"]
    let str_till_cursor_pos=strpart(curr_line,0,cursor_pos)
    let reversed_str=join(reverse(split(str_till_cursor_pos, '.\zs')), '')

    for char in split(reversed_str, '\zs')
        let value_found_at = index(brackets, char)

        if(value_found_at >= 0)
            if(a:commandType ==? 'change')
              execute "normal! ci".char

              :normal! l
              :startinsert
            elseif(a:commandType==?'delete')
              execute "normal! ci".char
            elseif(a:commandType==? 'select')
              execute "normal! vi".char
            elseif(a:commandType==? 'yank')
              execute "normal! yi".char
            endif

            break
        endif
    endfor
endfunction

" command! ModifyInsideBrackets call ModifyInsideBrackets()
nmap dib :call ModifyInsideBrackets("delete")<CR>
nmap cib :call ModifyInsideBrackets("change")<CR>
nmap vib :call ModifyInsideBrackets("select")<CR>
nmap yib :call ModifyInsideBrackets("yank")<CR>

function! JsonFormat()
    if(&ft=='json')
        :%!jq .
    endif
endfunction
command! JsonFormat call JsonFormat()

function! ModifyAroundBrackets(commandType) abort
    let curr_line=getline('.')
    let cursor_pos=col('.')

    let brackets = ["[", "]", "(", ")", "{", "}", "\"", "'", "<", ">"]
    let str_till_cursor_pos=strpart(curr_line,0,cursor_pos)
    let reversed_str=join(reverse(split(str_till_cursor_pos, '.\zs')), '')

    for char in split(reversed_str, '\zs')
        let value_found_at = index(brackets, char)

        if(value_found_at >= 0)
            if(a:commandType ==? 'change')
              execute "normal! ca".char

              :normal! l
              :startinsert
            elseif(a:commandType==?'delete')
              execute "normal! ca".char
            elseif(a:commandType==? 'select')
              execute "normal! va".char
            elseif(a:commandType==? 'yank')
              execute "normal! ya".char
            endif

            break
        endif
    endfor
endfunction

nmap dab :call ModifyAroundBrackets("delete")<CR>
nmap cab :call ModifyAroundBrackets("change")<CR>
nmap vab :call ModifyAroundBrackets("select")<CR>
nmap yab :call ModifyAroundBrackets("yank")<CR>

]]

vim.cmd [[
""""""Plugins""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fugitive
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap   gs    :Git status<CR>
nnoremap   gp    :Git pull<CR>
nnoremap   gps   :Git push<CR>
nnoremap   gpf   :Git push --force<CR>
nnoremap   gr    :Gread<CR>
nnoremap   gw    :Gwrite<CR>
nnoremap   gcm   :Git commit --m ""
nnoremap   gco   :Git commit<CR>
nnoremap   gca   :Gwrite<CR>:Git commit --amend<CR>
nnoremap   gbl   :Git blame<CR>
nnoremap   gd    :Gvdiff<CR>

let g:gtfo#terminals = { 'win': 'pwsh.exe -NoLogo -NoExit -Command' }

" imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
" let g:copilot_no_tab_map = v:true

let g:vim_json_syntax_conceal = 0

" => lightspeed settings
nmap <leader>o <Plug>Lightspeed_s

" => dial settings
nmap  <M-a>  <Plug>(dial-increment)
nmap  <M-x>  <Plug>(dial-decrement)
nmap g<M-a> g<Plug>(dial-increment)
nmap g<M-x> g<Plug>(dial-decrement)
vmap  <M-a>  <Plug>(dial-increment)
vmap  <M-x>  <Plug>(dial-decrement)
vmap g<M-a> g<Plug>(dial-increment)
vmap g<M-x> g<Plug>(dial-decrement)

" => gitlinker settings
command! Gblame :GitLink!
]]

----------------------- TELESCOPE CONFIG -------------------------

vim.cmd [[
" FindRootDirectory is from https://github.com/airblade/vim-rooter
nmap <expr> <leader>n ':Telescope find_files cwd='.FindRootDirectory().'/<cr>'
nmap <leader>t :Telescope oldfiles<cr>
nmap <leader>g :Telescope live_grep<cr>
"search word under the cursor
nmap <expr> <leader>cf ':Telescope grep_string cwd='.FindRootDirectory().'/<cr>'

" nnoremap p "0p
nnoremap pl :Telescope neoclip<cr>
]]

local actions = require "telescope.actions"
require("telescope").setup {
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
    },
  },
  pickers = {
    buffers = {
      mappings = {
        i = {
          ----------- Mapping <C-d> to delete buffer --------
          ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
        },
      },
    },
  },
}

----------------------- HARPOON CONFIG -------------------------
local harpoon = require "harpoon"
harpoon:setup {}

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Harpoon",
      finder = require("telescope.finders").new_table {
        results = file_paths,
      },
      previewer = conf.file_previewer {},
      sorter = conf.generic_sorter {},
    })
    :find()
end

vim.keymap.set("n", "<C-o>", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)

-------------- Falling back to find_files if git_files can't find a .git directory ----------
--[[
local M = {}

-- We cache the results of "git rev-parse"
-- Process creation is expensive in Windows, so this reduces latency
local is_inside_work_tree = {}

M.project_files = function()
  local opts = {} -- define here if you want to define something

  local cwd = vim.fn.getcwd()
  if is_inside_work_tree[cwd] == nil then
    vim.fn.system("git rev-parse --is-inside-work-tree")
    is_inside_work_tree[cwd] = vim.v.shell_error == 0
  end

  if is_inside_work_tree[cwd] then
    builtin.git_files(opts)
  else
    builtin.find_files(opts)
  end
end

return M

-- call via:
-- :lua require"telescope-config".project_files()

-- example keymap:
-- vim.api.nvim_set_keymap("n", "<Leader><Space>", "<CMD>lua require'telescope-config'.project_files()<CR>", {noremap = true, silent = true})

]]
--

----------------------- TELESCOPE CONFIG END -------------------------

----------------------- NVIM-TREESITTER CONFIG -------------------------
require("nvim-treesitter.install").prefer_git = true

require("nvim-treesitter.configs").setup {
  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        -- ["ab"] = "@block.outer",
        -- ["ib"] = "@block.inner",
        -- You can also use captures from other query groups like `locals.scm`
        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ["@parameter.outer"] = "v", -- charwise
        ["@function.outer"] = "V", -- linewise
        ["@class.outer"] = "<c-v>", -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true of false
      include_surrounding_whitespace = true,
    },
  },
}

----------------------- NVIM-TREESITTER CONFIG END -------------------------

if
  package.config:sub(1, 1) == "\\" --if OS is Windows
then
  -- Enable powershell as your default shell
  vim.opt.shell = "pwsh.exe -NoLogo"
  vim.opt.shellcmdflag =
    "-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  vim.cmd [[
    let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    set shellquote= shellxquote=

    nnoremap <leader>c :e ~/AppData/Local/nvim/init.lua<cr>
    nnoremap <leader>p :e ~/AppData/Local/nvim/lua/plugins/user.lua<cr>

    ]]
else
  vim.cmd [[
    nnoremap <leader>c :e ~/.config/nvim/init.lua<cr>
    nnoremap <leader>p :e ~/.config/nvim/lua/plugins/user.lua<cr>

    set clipboard=unnamedplus
    let g:clipboard = {
                \   'name': 'WslClipboard',
                \   'copy': {
                \      '+': 'clip.exe',
                \      '*': 'clip.exe',
                \    },
                \   'paste': {
                \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
                \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
                \   },
                \   'cache_enabled': 0,
                \ }

      command! FormatJson :%!jq .
    ]]
end

-- require("lspconfig").lua_ls.setup {
--   settings = {
--     workspace = { checkThirdParty = false },
--   },
-- }

-- make sure to run this code before calling setup()
-- -- refer to the full lists at https://github.com/folke/which-key.nvim/blob/main/lua/which-key/plugins/presets/init.lua
-- local presets = require "which-key.plugins.presets"
-- presets.operators["v"] = nil
-- presets.operators["c"] = nil
-- presets.operators["p"] = nil
-- presets.operators["y"] = nil
-- presets.operators["<"] = nil

require("mason-lspconfig").setup {
  ensure_installed = {
    "powershell_es",
    "lua_ls",
    "pyright",
    "jsonls",
    "yamlls",
    "bashls",
    -- "csharp_ls",
    "vimls",
    "ts_ls",
    "graphql",
  },
}

-- vim-rooter alternative for nvim 10.x
-- vim.api.nvim_create_autocmd("BufEnter", {
--   callback = function(ctx)
--     local root = vim.fs.root(ctx.buf, { ".git", ".svn", "package.json", "!node_modules", "Makefile" })
--     if root then vim.uv.chdir(root) end
--   end,
-- })

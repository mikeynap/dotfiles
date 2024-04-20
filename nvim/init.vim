syntax on
set number relativenumber
set hlsearch
set ignorecase smartcase
set incsearch
set nocompatible
set showcmd                           " Show size of visual selection
set tabstop=4
set softtabstop=4
set expandtab
set termguicolors
set shiftwidth=4
set complete=
set showtabline=1
set shell=~/usr/bin/bash
set path+=**                          " Search recursively through directories
set autoread                          " Auto reload changed files
set wildmenu                          " Tab autocomplete in command mode
set wildignorecase                    " Ignore case when searching for files
set pumheight=10
set background=dark
set updatetime=500
set signcolumn=yes
set foldmethod=syntax
set nofoldenable

colorscheme hybrid_material
let $BASH_ENV="/home/napolitm/.vim_bash_env"
let mapleader=","

function! HideLineNumbers()
    set norelativenumber
    set nonumber
endfunction

" === Macros === " 
function! HeaderToggle()
    let filename = expand("%:t")
    let r = expand("%:t:r")
    let h = r . ".cpp"
    if filename =~ ".cpp"
        let h = r . ".h"
    endif
    exec "find " . h
endfunction


" === Macros === " 
function! TestToggle()
    let filename = expand("%:t")
    let r = expand("%:t:r")
    let h = "test" . r . ".cpp"
    if filename =~ "test.*"
        let h = substitute(r, "test", "", "") . ".h"
    endif
    exec "find " . h
endfunction


" === Plugin Configs ==="

" ==== Airline Config ====" 

let g:airline#extensions#tabline#enabled = 1
let g:thisRepoBase = fnamemodify(getcwd(), ":t")
let g:airline_section_x = g:thisRepoBase

" ==== System Plugins Config ===="
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide='/\.vs,Build/.*,Libraries/.*,Include/.*,Resources/Objects/.*,Resources/Textures/.*,Pipfile\.lock,log,conf,tags,\(^\|\s\s\)\zs\.\S\+'
let g:formatters_c = ['clangformat']
let g:formatters_cpp = ['clangformat']

" === Plugins === "
call plug#begin('~/.vim/plugged')
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-abolish'
Plug 'windwp/nvim-autopairs'
Plug 'vim-autoformat/vim-autoformat'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'terryma/vim-expand-region'
Plug 'google/vim-maktaba'
Plug 'bazelbuild/vim-bazel'
Plug 'github/copilot.vim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
Plug 'MunifTanjim/nui.nvim'
Plug 'sindrets/diffview.nvim'
Plug 'stevearc/dressing.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'harrisoncramer/gitlab.nvim'
Plug 'mikeynap/telescope-coc.nvim'
Plug 'tpope/vim-repeat'
Plug 'ggandor/leap.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'AlexvZyl/nordic.nvim', { 'branch': 'main' }
Plug 'sainnhe/sonokai'
Plug 'nvim-telescope/telescope-live-grep-args.nvim'

call plug#end()

"=== Plugin PostSetup === " 
syn on
lua << EOF
require("diffview").setup()
require("nvim-autopairs").setup {}
-- To get fzf loaded and working with telescope, you need to call
require('user.telescope')
require('leap').create_default_mappings() 
--require 'nordic' .load()

require('telescope').load_extension("live_grep_args")
require('telescope').load_extension("fzf")
require("telescope").load_extension("file_browser")
vim.api.nvim_set_keymap(
  "n",
  "<leader>fb",
  ":Telescope file_browser<CR>",
  { noremap = true }
)

-- open file_browser with the path of the current buffer
vim.api.nvim_set_keymap(
  "n",
  "<leader>fp",
  ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
  { noremap = true }
)

vim.keymap.set("n", "<C-f>", function() require("telescope").extensions.live_grep_args.live_grep_args( 
    { search_dirs = {"cpp"},
  vimgrep_arguments = {
    -- all required except `--smart-case`
    "rg",
    "--color=never",
    "--no-heading",
    "--with-filename",
    "--line-number",
    "--column",
    "--smart-case",
    -- add your options
	"--ignore-file=/~.testignore"
  } }) end, opts)

vim.keymap.set("n", "gor", "<cmd>Telescope coc request<cr>")
vim.keymap.set("n", "gom", "<cmd>Telescope coc onMessage<cr>")
vim.keymap.set("n", "gr", "<cmd>Telescope coc references<cr>")
vim.keymap.set("n", "gw", "<cmd>Telescope buffers<cr>")
local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
vim.keymap.set("n", "gs", live_grep_args_shortcuts.grep_word_under_cursor)


require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "cpp", "python", "bash", "json", "yaml", "dockerfile"},

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 1000 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}


EOF
let g:airline_theme = 'sonokai'
let g:sonokai_style = 'maia'
"let g:sonokai_style = 'shusia'
let g:sonokai_disable_italic_comment = 1

colorscheme sonokai

" === Keybinds === "


" ==== Files ==== "

noremap <Leader><Tab> :bnext<CR>
noremap <Leader>1 :bprev<CR>
noremap <Leader>2 :bnext<CR>

""" noremap <Leader>f :NERDTreeToggle<CR> """

nnoremap <leader>h :call HeaderToggle()<cr>
nnoremap <leader>l :call HideLineNumbers()<cr>
nnoremap <leader>u :call TestToggle()<cr>

" ==== CoQ ==== "
inoremap <silent><expr> <c-space> coc#refresh()
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <leader> gn <Plug>(coc-git-nextchunk)
nmap <leader> gp <Plug>(coc-git-prevchunk)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap gf  <Plug>(coc-fix-current)
" Run the Code Lens action on the current line
nmap <leader>al  <Plug>(coc-codelens-action)
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
autocmd CursorHold * silent call CocActionAsync('highlight')
nmap <leader>rn <Plug>(coc-rename)

" === Other === "
nnoremap <Leader>j 20j<cr>
nnoremap <Leader>q :bd<cr>
nnoremap <SPACE> <Nop>
inoremap <c-w> <c-o>:w<cr>

" Make paste not override buffer "
xnoremap p pgvy

" Select right hand side "
xno ie g_oT<space>
ono ie :normal vie<cr>

" === Window Management === "
command -bar -nargs=+ -complete=buffer Sbuffers execute map([<f-args>], {_, b -> printf("sbuffer %s", b)})->join("|")
nnoremap <leader>z :ls<cr>:Sbuffers<space>
command -bar -nargs=+ -complete=buffer Vbuffers execute map([<f-args>], {_, b -> printf("vsplit \#%s", b)})->join("|")
nnoremap <leader>v :ls<cr>:Vbuffers<space>
nnoremap <Leader>w <C-w><C-w>
tnoremap <Esc> <C-\><C-n>
tnoremap <Leader>w <C-\><C-n><C-w><C-w>

" === Commands === "
nmap <silent> gb :Git blame<CR>
command Vimc :e ~/.config/nvim/init.vim
command Source :source ~/.config/nvim/init.vim

command -nargs=1 SaveAs :execute 'saveas ' . expand('%:h') . '/' . <q-args>
command Ls :! 'ls' '%:h'

fun CurrentDirFileList(A,L,P)
    return split(system('ls ' . expand('%:h')), '\n')
endfun
command -nargs=1 -complete=customlist,CurrentDirFileList Edit :execute 'edit ' . expand('%:h') . '/' . <q-args> 
command -nargs=0 EditAll :execute 'args %:h/*'

:nmap <silent> <space> "=nr2char(getchar())<cr>P

" === Remove trailing whitespace on save === "
autocmd FileType c,cpp,java,php autocmd BufWritePre <buffer> %s/\s\+$//e

" convert line to string with comma at end "
map <Leader>" ysiW"$a,<Esc>^

" == Copilot == "
inoremap <C-\> <Plug>(copilot-next)
imap <silent><script><expr><C-J> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

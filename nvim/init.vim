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

function Get_current_function() abort
      return get(b:, 'coc_current_function', '')
endfunction

let g:airline#extensions#tabline#enabled = 1
let g:thisRepoBase = fnamemodify(getcwd(), ":t")
let g:airline_section_x = g:thisRepoBase
let g:airline_section_y = '%{Get_current_function()}'

" ==== System Plugins Config ===="
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide='/\.vs,Build/.*,Libraries/.*,Include/.*,Resources/Objects/.*,Resources/Textures/.*,Pipfile\.lock,log,conf,tags,\(^\|\s\s\)\zs\.\S\+'
let g:formatters_c = ['clangformat']
let g:formatters_cpp = ['clangformat']

let g:python3_host_prog = "/usr/bin/python3"

" === Plugins === "
call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-scripts/ReplaceWithRegister'
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

call plug#end()

"=== Plugin PostSetup === " 
syn on
lua << EOF
require("diffview").setup()
require("nvim-autopairs").setup {}
-- To get fzf loaded and working with telescope, you need to call
require('user.telescope')
require('telescope').load_extension('fzf')
EOF

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
nmap <silent> gr <Plug>(coc-references)
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>af  <Plug>(coc-fix-current)
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

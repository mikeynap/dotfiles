syntax on
set number
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
set shell=/ctc/users/napolitm/usr/bin/bash
set path+=**                          " Search recursively through directories
set autoread                          " Auto reload changed files
set wildmenu                          " Tab autocomplete in command mode
set wildignorecase                    " Ignore case when searching for files
set pumheight=10
set background=dark

colorscheme hybrid_material
let $BASH_ENV="/home/napolitm/.vim_bash_env"
let mapleader=","


" === Macros === " 
function! HeaderToggle()
    let filename = expand("%:t")
    if filename =~ ".cpp"
        execute "e %:r.h"
    else
        execute "e %:r.cpp"
    endif
endfunction

" === Plugin Configs ==="

" ==== ALE Config ==== "
let g:ale_disable_lsp = 1
let g:ale_c_build_dir_names = ['build', 'build-debug']
let g:ale_c_cc_executable = "/usr/bin/clang"
let g:ale_c_clangtidy_executable = "/usr/bin/clang-tidy"
let g:ale_c_clangformat_executable = "/usr/bin/clang-format"
let g:ale_cpp_cc_executable = "/usr/bin/clang++"
let g:ale_cpp_cc_options = '--gcc-toolchain=~/usr/gcc12/'
let g:ale_completion_enabled = 0

" ==== Airline Config ====" 
let g:airline#extensions#tabline#enabled = 1

" ==== System Plugins Config ===="
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide='/\.vs,Build/.*,Libraries/.*,Include/.*,Resources/Objects/.*,Resources/Textures/.*,Pipfile\.lock,log,conf,tags,\(^\|\s\s\)\zs\.\S\+'
let g:formatters_c = ['clangformat']
let g:formatters_cpp = ['clangformat']

" ==== NerdTree Config ==== "
" Automatically open NERDTree when opening a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
" Close vim if only NERDTree exists
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" ==== FloaTerm Config ==== "

let g:floaterm_keymap_toggle = '<Leader>t'
let g:floaterm_wintype = 'split'
let g:floaterm_height = 0.3
let g:floaterm_shell = 'tmux -u attach-session -t vim || tmux new -t vim'
autocmd bufenter * if (winnr("$") == 1 && &buftype == "terminal") | q | endif

" === Plugins === "
call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'windwp/nvim-autopairs'
Plug 'voldikss/vim-floaterm'
call plug#end()

"=== Plugin PostSetup === " 
syn on
lua << EOF
require("nvim-autopairs").setup {}
EOF

" === Keybinds === "

" ==== Files ==== "
nnoremap <C-f> :Rg<cr>
nnoremap <C-p> :GFiles<cr>
nnoremap <Leader>p :GFiles %:p:h<cr>
nnoremap <Leader>[ :Files /<cr>
noremap <Leader><Tab> :bnext<CR>
noremap <Leader>f :NERDTreeToggle %<CR>
nnoremap <leader>h :call HeaderToggle()<cr>

" ==== CoQ ==== "
inoremap <silent><expr> <c-space> coc#refresh()
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" === Other === "
imap ;; <Esc>
nnoremap <SPACE> <Nop>


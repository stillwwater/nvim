" vim:ts=4:sw=4:ai:foldmethod=marker:foldlevel=1:
" ----------------------------------------------------------------------------
" Name:     init.vim
" Version:  12.8
" Date:     2022-07-01
" Modified: 2026-01-21
" Author:   stillwwater@gmail.com
" ----------------------------------------------------------------------------

" PLUGINS ---------------------------------------------------------------- {{{
call plug#begin()
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'junegunn/vim-easy-align'
"Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
Plug 'stillwwater/wm.vim'
call plug#end()

lua require('plugins')
" }}}

" OPTIONS ---------------------------------------------------------------- {{{
syntax on
set mouse=a
set tabstop=4 shiftwidth=4 softtabstop=4
set backspace=indent,eol,start
set expandtab
set smartindent
set laststatus=2
set showtabline=2
set noerrorbells
set belloff=all
set noignorecase
set smartcase
set incsearch
set hlsearch
set encoding=utf-8
set fileformat=unix
set fileformats=unix,dos
set completeopt=
set pumheight=12
set pumwidth=10
set clipboard=unnamedplus
set guicursor=
set nofoldenable
set foldlevel=99
set foldmethod=syntax
set signcolumn=yes
set textwidth=90            " gw wraps at 90 columns
set clipboard=unnamedplus
set signcolumn=yes          " gutter
set scrolloff=5             " scroll margins
set ttyfast

set cino=N-s  " Don't indent namespace
set cino+=:0  " Don't indent switch labels
set cino+=l1  " Don't align case braces
set cino+=L0  " Don't auto unindent labels
set cino+=g0  " Don't indent public: or private: labels

nohlsearch

let c_no_curly_error = 0 " vim doesn't like C99 braces

let g:mkdp_auto_close = 0
let g:mkdp_refresh_slow = 0
let g:mkdp_markdown_css = ''

let g:matchparen_timeout = 6
let g:matchparen_insert_timeout = 6

let g:easy_align_delimiters = {
  \ '\': {
  \     'pattern': '\\$',
  \ },
  \ }

" }}}

" AUTOCOMMANDS ----------------------------------------------------------- {{{
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd FileType make setlocal noexpandtab
" }}}

" KEYMAP ----------------------------------------------------------------- {{{
let mapleader = ','

nnoremap <leader>r :source $MYVIMRC<CR>
nnoremap <leader>v :e $MYVIMRC<CR>
nnoremap <leader>V :e $MYVIMRC/..<CR>
nnoremap <PageUp> <PageUp>zz
nnoremap <PageDown> <PageDown>zz
nnoremap <C-Up> {
nnoremap <C-Down> }
nnoremap <C-k> {
nnoremap <C-j> }
nnoremap <leader>h :ClangdSwitchSourceHeader<CR>
nnoremap <C-l> :nohl<CR><C-l>
nnoremap <leader>tm :echo synIDattr(synID(line('.'), col('.'), 1), 'name')<CR>
nnoremap <C-c> i
nnoremap ga <Plug>(EasyAlign)
nnoremap <leader>l :hi Normal guibg=#22272E guifg=gray76<CR>
nnoremap <leader>L :hi Normal guibg=gray8 guifg=gray68<CR>

if has('win32')
    nnoremap <C-s> :!nmake /nologo /s run<CR>
endif

inoremap <C-n> <cmd>lua require('cmp').complete()<CR>
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<C-Tab>"
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"

tnoremap <Esc> <C-\><C-n>
" }}}

" COLORS ----------------------------------------------------------------- {{{
set termguicolors
hi clear
set background=dark
colorscheme lunaperche

hi link Function Normal
hi Normal           guifg=gray68           guibg=gray8  gui=none

hi Todo             guifg=bg               guibg=lightblue gui=none
hi NonText          guifg=slategray4
hi ExtraWhitespace  guifg=red              guibg=red
hi StatusLine       guifg=bg               guibg=fg     gui=none
hi StatusLineNC     guifg=gray36           guibg=fg     gui=none
hi TabLineFill      guifg=bg               guibg=bg     gui=none
hi TabLineSel       guifg=bg               guibg=white  gui=none
hi TabLine          guifg=bg               guibg=gray46 gui=none

hi VertSplit        guifg=fg               guibg=none
hi Visual           guifg=none             guibg=bg     gui=inverse
hi MatchParen       guifg=none             guibg=bg     gui=inverse
hi Pmenu            guifg=bg               guibg=fg
hi PmenuSel         guifg=bg               guibg=fg     gui=inverse

" Hover menu (K)
hi NormalFloat      guibg=bg               guifg=fg
hi FloatBorder      guibg=none             guifg=fg

hi link rustSigil Normal
" }}}

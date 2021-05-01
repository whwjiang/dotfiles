call plug#begin('~/.local/share/nvim/plugged')

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'zchee/deoplete-jedi'
let g:deoplete#enable_at_startup = 1

Plug 'vim-airline/vim-airline'

Plug 'vim-airline/vim-airline-themes'

Plug 'jiangmiao/auto-pairs'

Plug 'scrooloose/nerdcommenter'

Plug 'sbdchd/neoformat'
" Enable alignment
let g:neoformat_basic_format_align = 1

" Enable tab to space conversion
let g:neoformat_basic_format_retab = 1

" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1

Plug 'davidhalter/jedi-vim'
" disable autocompletion, because we use deoplete for completion
let g:jedi#completions_enabled = 0

" open the go-to function in split, not another buffer
let g:jedi#use_splits_not_buffers = "right"

Plug 'scrooloose/nerdtree'
let NERDTreeShowHidden=1

Plug 'neomake/neomake'
let g:neomake_python_enabled_makers = ['flake8']

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh'
    \ }

Plug 'machakann/vim-highlightedyank'

call plug#end()

autocmd VimEnter * NERDTree

:set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

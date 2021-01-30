" TODO

source ~/.vimrc_noplugin

call plug#begin('~/.config/nvim/plugged')


" CtrlP(unite)
" cfg_ctrlp
Plug 'ctrlpvim/ctrlp.vim'

" Language Server Client
" :CocInstall coc-python coc-tsserver
" :CocInstall coc-highlight
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" tsx
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'


call plug#end()


set termguicolors



" CtrlP Vim
" cfg_ctrlp
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_show_hidden = 1
let g:ctrlp_line_prefix = '' " 

let g:ctrlp_user_command = {
    \ 'types': {
        \ 1: ['.git', 'cd %s && { git ls-files; git ls-files . --exclude-standard --others; } | grep -v __generated__'],
        \ 2: ['.hg', 'hg --cwd %s locate -I . | grep -v __generated__'],
        \ },
    \ 'fallback': 'find %s -type f'
    \ }
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:20,results:20'
" disable on ControlP
autocmd BufEnter ControlP let b:ale_enabled = 0


" Coc settings
let g:coc_global_extensions = [ 'coc-tsserver' ]

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

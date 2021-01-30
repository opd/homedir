" TODO

source ~/.vimrc_noplugin

call plug#begin('~/.config/nvim/plugged')


" CtrlP(unite)
" cfg_ctrlp
Plug 'ctrlpvim/ctrlp.vim'

" Language Server Client
" :CocInstall coc-python coc-tsserver coc-highlight
" coc_cfg
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" tsx hightlighting
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" cfg_colortheme
Plug 'flazz/vim-colorschemes'

" Tmux move
Plug 'christoomey/vim-tmux-navigator'

" cfg_ack
Plug 'mileszs/ack.vim'

"" cfg_airline
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
"
"" cfg_git to show current branch in airline
"Plug 'tpope/vim-fugitive'

" cfg_lightline
Plug 'itchyny/lightline.vim'

" show current method
Plug 'liuchengxu/vista.vim'


" RANGER
" \ f
Plug 'francoiscabrol/ranger.vim'

" 
Plug 'ryanoasis/vim-devicons'


call plug#end()


" cfg_colortheme
colorscheme molokai
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


" coc_cfg
let g:coc_global_extensions = [ 'coc-tsserver', 'coc-styled-components', 'coc-highlight', 'coc-python', 'coc-git' ]

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" cfg_ack
let g:ackprg = 'python3 ~/.bin/search.py'
let g:ack_autoclose = 1

cnoreabbrev Ag Ack
cnoreabbrev Rg Ack
cnoreabbrev Agmo Ack -G \/models.py<C-b><Right><Right><Right>
cnoreabbrev Agv Ack -G \/views.py<C-b><Right><Right><Right>
cnoreabbrev Agu Ack -G \/urls.py<C-b><Right><Right><Right>
cnoreabbrev Agt Ack -G \/test_<C-b><Right><Right><Right>
cnoreabbrev Agf Ack -G \/factories.py<C-b><Right><Right><Right>
cnoreabbrev Agcm Ack class\ -w -G \/models.py<C-b><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right>

"" cfg_airline
"let g:airline_powerline_fonts = 1
"" let g:airline#extensions#tagbar#flags = 'f'
"
"let g:airline_mode_map = {
"      \ '__' : '-',
"      \ 'n' : 'N',
"      \ 'i' : 'I',
"      \ 'R' : 'R',
"      \ 'c' : 'C',
"      \ 'v' : 'V',
"      \ 'V' : 'V',
"      \ 's' : 'S',
"      \ 'S' : 'S',
"      \ }
"let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
"" Don't show file type
"" let g:airline_section_x='%{airline#util#prepend(airline#extensions#tagbar#currenttag(),0)}%{airline#util#prepend("", 0)}'
"" let g:airline_section_x='%{airline#util#prepend("", 0)}'
"" default..
"" let g:airline_section_z='%3p%% %#__accent_bold#%{g:airline_symbols.linenr}%4l%#__restore#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__# :%3v'
"" modified, remove spaces
"" let g:airline_section_z='%p%%%#__accent_bold#%{g:airline_symbols.linenr}%l%#__restore#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__#:%v'
"" cfg_capslock
"" let g:airline#extensions#capslock#enabled = 1
"let g:airline_skip_empty_sections = 1
"" determine whether inactive windows should have the left section collapsed to
"" only the filename of that buffer.  >
"let g:airline_inactive_collapse = 1
"let g:airline#extensions#hunks#coc_git = 1
"
"" enable only this extensions
"" let g:airline#extensions#hunks#non_zero_only = 1
"" let g:airline#extensions#virtualenv#enabled = 0
"" cfg_devicons
"let g:webdevicons_enable_airline_statusline_fileformat_symbols = 0


function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

set statusline+=%{NearestMethodOrFunction()}

" By default vista.vim never run if you don't call it explicitly.
"
" If you want to show the nearest function in your statusline automatically,
" you can add the following line to your vimrc
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()


let g:vista_default_executive = 'coc'



let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'method', 'cocstatus', 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \   'cocstatus': 'coc#status',
      \   'method': 'NearestMethodOrFunction'
      \ },
      \ }


let g:lightline.mode_map = {
      \ '__' : '-',
      \ 'n' : 'N',
      \ 'i' : 'I',
      \ 'R' : 'R',
      \ 'c' : 'C',
      \ 'v' : 'V',
      \ 'V' : 'V',
      \ 's' : 'S',
      \ 'S' : 'S',
      \ }

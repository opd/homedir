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

" run background processes (for cfg_ack)
Plug 'tpope/vim-dispatch'

"" cfg_airline
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
"
"" cfg_git to show current branch in airline
"Plug 'tpope/vim-fugitive'

" cfg_lightline
Plug 'itchyny/lightline.vim'

" show current method
" cfg_vista
Plug 'liuchengxu/vista.vim'


" RANGER
" \ f
Plug 'francoiscabrol/ranger.vim'

" 
Plug 'ryanoasis/vim-devicons'

"" CHANGE BRACES
" cs"' inside "Hello world!" to change it to 'Hello world!'
" cs<tag> - wrap with tag
" S - wrap in visual mod
" ds" - delete wrap
Plug 'tpope/vim-surround'

" adjusts 'shiftwidth' and 'expandtab' from current file
" :Sleuth Manually detect indentation
Plug 'tpope/vim-sleuth'

" {prefix) - <Leader>
" {prefix}w
" vi{prefix}w
" cfg_wordmotion
Plug 'chaoren/vim-wordmotion'

" switch True <=> False and etc.
" '-' - to switch
" cfg_switch
Plug 'AndrewRadev/switch.vim'


" Comments
Plug 'preservim/nerdcommenter'

" [- : Move to previous line of lesser indent than the current line.
" [+ : Move to previous line of greater indent than the current line.
" [= : Move to previous line of same indent as the current line that is separated from the current line by lines of different indents.
Plug 'jeetsukumaran/vim-indentwise'


" multiselect
Plug 'mg979/vim-visual-multi', {'branch': 'master'}


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
let g:coc_global_extensions = [ 'coc-tsserver', 'coc-styled-components', 'coc-highlight', 'coc-python', 'coc-git', 'coc-pairs', 'coc-prettier' ]

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" cfg_ack
" let g:ackprg = 'python3 ~/.bin/search.py'
let g:ackprg = '~/.bin/search.py'
let g:ack_autoclose = 1
cnoreabbrev Ag Ack
cnoreabbrev Rg Ack
cnoreabbrev Agmo Ack -G \/models.py<C-b><Right><Right><Right>
cnoreabbrev Agv Ack -G \/views.py<C-b><Right><Right><Right>
cnoreabbrev Agu Ack -G \/urls.py<C-b><Right><Right><Right>
cnoreabbrev Agt Ack -G \/test_<C-b><Right><Right><Right>
cnoreabbrev Agf Ack -G \/factories.py<C-b><Right><Right><Right>
cnoreabbrev Agcm Ack class\ -w -G \/models.py<C-b><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right>
let g:ackhighlight = 1
let g:ack_use_dispatch = 1
" idk
" let g:ack_qhandler = "botright copen 30"
" Use this option to automagically open the file with 'j' or 'k'.
let g:ackpreview = 1
let g:ack_use_cword_for_empty_search = 1

" cfg_vista cfg_lightline
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


" cfg_lightline
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


" Fix syntax
doautocmd Syntax

" cfg_wordmotion
let g:wordmotion_prefix = '<Leader>'

" cfg_coc
"" Remap <C-f> and <C-b> for scroll float windows/popups.
" nnoremap <expr><C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
" nnoremap <expr><C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
" inoremap <expr><C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<Right>"
" inoremap <expr><C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<Left>"
"

" cfg_switch
let g:switch_custom_definitions =
    \ [
    \   ['!==', '===']
    \ ]

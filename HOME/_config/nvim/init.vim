" vim: foldmethod=marker:foldlevel=0
"
set nocompatible

" PLUGINS {{{
" PLUG SETTINGS {{{
if has('nvim')
    if empty(glob('~/.config/nvim/autoload/plug.vim'))
        silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
    call plug#begin('~/.config/nvim/plugged')
else
    call plug#begin('~/.vim/plugged')
endif
if exists('g:loaded_plug')
" }}}
"    ___  ___                                    _
"    |  \/  |                                   | |
"    | .  . | _____   _____ _ __ ___   ___ _ __ | |_
"    | |\/| |/ _ \ \ / / _ \ '_ ` _ \ / _ \ '_ \| __|
"    | |  | | (_) \ V /  __/ | | | | |  __/ | | | |_
"    \_|  |_/\___/ \_/ \___|_| |_| |_|\___|_| |_|\__|

" MOVEMENT {{{
" CamelCaseACRONYMWords_underscore1234
" {prefix) - <Leader>
" {prefix}w
" vi{prefix}w
" cfg_wordmotion
Plug 'chaoren/vim-wordmotion'
" Brings physics-based smooth scrolling to the Vim/Neovim world!
" cfg_comfortablemotion
Plug 'yuttie/comfortable-motion.vim'

" [- : Move to previous line of lesser indent than the current line.
" [+ : Move to previous line of greater indent than the current line.
" [= : Move to previous line of same indent as the current line that is separated from the current line by lines of different indents.
Plug 'jeetsukumaran/vim-indentwise'

"" EasyMotion
"" :help easymotion
" \s - search forward backward
Plug 'easymotion/vim-easymotion'
" }}}
"   oooooooooooo       .o8   o8o      .    o8o
"   `888'     `8      "888   `"'    .o8    `"'
"    888          .oooo888  oooo  .o888oo oooo  ooo. .oo.    .oooooooo
"    888oooo8    d88' `888  `888    888   `888  `888P"Y88b  888' `88b
"    888    "    888   888   888    888    888   888   888  888   888
"    888       o 888   888   888    888 .  888   888   888  `88bod8P'
"   o888ooooood8 `Y8bod88P" o888o   "888" o888o o888o o888o `8oooooo.
"                                                           d"     YD
"                                                           "Y88888P'
" Editing {{{


"" QUOT, ETC. CLOSING
"" Shift+Tab, Ctrl+g g
""       Type   |  You get
""   =======================
""      (       |    (|)
""   -----------|-----------
""      ()      |    ()|
""   -----------|-----------
""   (<S-Tab>   |    ()|
""   -----------|-----------
""   {("<C-G>g  |  {("")}|
" Plug 'Raimondi/delimitMate'
" ^q ] - for inserting brace. (Standard vim)
Plug 'jiangmiao/auto-pairs'

"" :StripWhitespace - remove whitespaces
Plug 'ntpeters/vim-better-whitespace'

" Like sublime
" Ctrl+n, Ctrl+p. Ctrl+x (skip)
Plug 'terryma/vim-multiple-cursors'
" VIS
"    Use V, v, or ctrl-v to visually mark some region.  Then use
"   :B cmd     (this command will appear as:   :'<,'>B cmd),
Plug 'vim-scripts/vis'


"" CHANGE BRACES
" cs"' inside "Hello world!" to change it to 'Hello world!'
" cs<tag> - wrap with tag
" S - wrap in visual mod
" ds" - delete wrap
Plug 'tpope/vim-surround'

" adjusts 'shiftwidth' and 'expandtab' from current file
" :Sleuth Manually detect indentation
Plug 'tpope/vim-sleuth'
" crs snake_case
" crm MixedCase
" crc camelCase
" cru UPPER_CASE
" cr- dash-case
" cr. dot.case
" cr<space> space case
" crt Title Case
Plug 'tpope/vim-abolish'

"" v     Expand selection area
Plug 'gorkunov/smartpairs.vim'

" "(["aa","sdf"])
" gS - split gJ - join
Plug 'AndrewRadev/splitjoin.vim'

" switch True <=> False and etc.
" '-' - to switch
" cfg_switch
Plug 'AndrewRadev/switch.vim'

" Move item under the cursor left or right
" cfg_sideways
Plug 'AndrewRadev/sideways.vim'


" Press <C-G>c in insert mode to toggle a temporary software caps lock, or gC in normal mode
" cfg_capslock
Plug 'tpope/vim-capslock'

" Ex. Render the visual selection in the doom font, centered in 90 columns:
" '<,'>FIGlet -w 90 -c -f doom" cfg_figlet
Plug 'fadein/vim-FIGlet'

" additions to `ga` (character representation)
Plug 'tpope/vim-characterize'

" emoji
" C-X C-E
Plug 'kyuhi/vim-emoji-complete'


" DRAWING
" Select rectangle then press '+O','+>','++>'
Plug 'gyim/vim-boxdraw'

" :UndotreeToggle
Plug 'mbbill/undotree'

" \p, \P  next, prev
" vmap S conflict with vim surround
" cfg_yankstack
" Plug 'maxbrunsfeld/vim-yankstack'


" }}}
"   oooo    ooo  .ooooo.   .oooo.o
"    `88.  .8'  d88' `"Y8 d88(  "8
"     `88..8'   888       `"Y88b.
"      `888'    888   .o8 o.  )88b
"       `8'     `Y8bod8P' 8""888P'
" VCS {{{
" cfg_myshitplugin
if !has('nvim')
  Plug 'opd/myshitplugin.vim'
endif
"" GIT
"" git wrapper
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" for mercurial & git. show changes
" ]c / [c - next-change, previous-change
" Plug 'sgur/vim-lazygutter'
"" mercurial wrapper
Plug 'ludovicchabant/vim-lawrencium'
Plug 'phleet/vim-mercenary'

" }}}
"  oooooooooooo  o8o  oooo
"  `888'     `8  `"'  `888
"   888         oooo   888   .ooooo.   .oooo.o
"   888oooo8    `888   888  d88' `88b d88(  "8
"   888    "     888   888  888ooo888 `"Y88b.
"   888          888   888  888    .o o.  )88b
"  o888o        o888o o888o `Y8bod8P' 8""888P'
" FILES {{{
" FILE TYPES {{{
" HTML {{{
"" HTML
" Expand on Ctrl+Y,
Plug 'mattn/emmet-vim'
"" match tag. SLOWWWW DOWN
" Plug 'gregsexton/MatchTag'
" }}}
" MARKDOWN
" cfg_markdown
" Plug 'plasticboy/vim-markdown'
" }}}

" CtrlP(unite)
" cfg_ctrlp
Plug 'ctrlpvim/ctrlp.vim'

" cfg_ag
" Plug 'rking/ag.vim'
" cfg_ack
Plug 'mileszs/ack.vim'
" TODO create Ag command
" Plug 'Chun-Yang/vim-action-ag'
" FILE
Plug 'scrooloose/nerdtree'
" RANGER
" \ f
Plug 'francoiscabrol/ranger.vim'
""Vim sugar for the UNIX shell commands that need it the most. Features include:
"" * :Remove: Delete a buffer and the file on disk simultaneously.
"" * :Unlink: Like :Remove, but keeps the now empty buffer.
"" * :Move: Rename a buffer and the file on disk simultaneously.
"" * :Rename: Like :Move, but relative to the current file's containing directory.
"" * :Chmod: Change the permissions of the current file.
"" * :Mkdir: Create a directory, defaulting to the parent of the current file.
"" * :Find: Run find and load the results into the quickfix list.
"" * :Locate: Run locate and load the results into the quickfix list.
"" * :Wall: Write every open window. Handy for kicking off tools like guard.
"" * :SudoWrite: Write a privileged file with sudo.
"" * :SudoEdit: Edit a privileged file with sudo.
"" * File type detection for sudo -e is based on original file name.
"" * New files created with a shebang line are automatically made executable.
"" * New init scripts are automatically prepopulated with /etc/init.d/skeleton.
Plug 'tpope/vim-eunuch'

" }}}
"  oooooooooo.    o8o                      oooo
"  `888'   `Y8b   `"'                      `888
"   888      888 oooo   .oooo.o oo.ooooo.   888   .oooo.   oooo    ooo
"   888      888 `888  d88(  "8  888' `88b  888  `P  )88b   `88.  .8'
"   888      888  888  `"Y88b.   888   888  888   .oP"888    `88..8'
"   888     d88'  888  o.  )88b  888   888  888  d8(  888     `888'
"  o888bood8P'   o888o 8""888P'  888bod8P' o888o `Y888""8o     .8'
"                                888                       .o..P'
"                               o888o                      `Y8P'
" DISPLAY {{{

" Slow down vim
Plug 'lyokha/vim-xkbswitch', {'for': ['txt', 'markdown']}

" Syntax with indents for all languages
Plug 'sheerun/vim-polyglot'

" SHOW '┆'
" cfg_indentline
Plug 'Yggdroot/indentLine'

" colors vim highlighting
" Plug 'chriskempson/base16-vim'
Plug 'crusoexia/vim-monokai'
Plug 'NLKNguyen/papercolor-theme'
Plug 'altercation/vim-colors-solarized'
" cfg_airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" cfg_devicons
Plug 'ryanoasis/vim-devicons'

" COLORS
Plug 'ap/vim-css-color', {'for': ['css', 'sass', 'scss', 'less', 'ts']}
" }}}
"    .oooooo.                   .o8   o8o
"   d8P'  `Y8b                 "888   `"'
"  888           .ooooo.   .oooo888  oooo  ooo. .oo.    .oooooooo
"  888          d88' `88b d88' `888  `888  `888P"Y88b  888' `88b
"  888          888   888 888   888   888   888   888  888   888
"  `88b    ooo  888   888 888   888   888   888   888  `88bod8P'
"   `Y8bood8P'  `Y8bod8P' `Y8bod88P" o888o o888o o888o `8oooooo.
"                                                      d"     YD
"                                                      "Y88888P'
" CODING {{{
" ALL {{{
"
" comments, commenter
" Language Server Client
" :CocInstall coc-python, coc-tsserver
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" cfg_caw
Plug 'tyru/caw.vim'
" check context file type for comments
Plug 'Shougo/context_filetype.vim'
" asynchronous execution library
" Plug 'Shougo/vimproc.vim'

"" BREAKS delimitMate, or not
""Completion on tab
" cfg_supertab
Plug 'ervandew/supertab'

" Syntax checking
" cfg_ale
Plug 'w0rp/ale'
if has('nvim')
  " Completion
  " Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  " Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

" cfg_language_client
" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }

" cfg_ultisnips
Plug 'sirver/ultisnips'
Plug 'honza/vim-snippets'
" Find and Replace
Plug 'brooth/far.vim'

Plug 'direnv/direnv.vim'


" COMPLETION
" Plug 'Valloric/YouCompleteMe'
" }}}
" PYTHON {{{
" :Ped django.shortcuts
Plug 'sloria/vim-ped'

autocmd FileType python vnoremap f :!~/.bin/format_python.py<CR>

" Best plugin!!
" \d - goto definition
" \n - show all the usages of a name
" cfg_jedi
Plug 'davidhalter/jedi-vim'

" TODO enable only for python
" <F8> toggle tagbar
" cfg_tagbar
Plug 'majutsushi/tagbar'
" black for python
" Plug 'ambv/black'
" }}}
" TYPESCRIPT {{{
" Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
" SETTINGS in typescript.vim
" Make your Vim a TypeScript IDE
" cfg_tsuquyomi
" Plug 'Quramy/tsuquyomi'
"
" if has('nvim')
"   Plug 'HerringtonDarkholme/yats.vim'
"   Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
"   " For Denite features
"   Plug 'Shougo/denite.nvim'
" endif
" }}}
" VUEJS {{{
" Syntax highlight
" cfg_vue
Plug 'posva/vim-vue'
" Plug 'Quramy/tsuquyomi-vue'


" }}}
" JAVASCRIPT {{{
"" JAVASCRIPT
"" Plug 'wokalski/autocomplete-flow'
Plug 'pangloss/vim-javascript'
" jsx
" cfg_vimjsx
Plug 'mxw/vim-jsx'
" highlight css`color: red` inside javascript
Plug 'styled-components/vim-styled-components'
" }}}
" }}}

"   ooooooooooooo   .oooooo.     .oooooo.   ooooo         .oooooo..o
"   8'   888   `8  d8P'  `Y8b   d8P'  `Y8b  `888'        d8P'    `Y8
"        888      888      888 888      888  888         Y88bo.
"        888      888      888 888      888  888          `"Y8888o.
"        888      888      888 888      888  888              `"Y88b
"        888      `88b    d88' `88b    d88'  888       o oo     .d8P
"       o888o      `Y8bood8P'   `Y8bood8P'  o888ooooood8 8""88888P'
" TOOLS {{{
" Save session
Plug 'tpope/vim-obsession'
" REPEAT
Plug 'tpope/vim-repeat'
" Tmux move
Plug 'christoomey/vim-tmux-navigator'

" run background processes
Plug 'tpope/vim-dispatch'
" }}}
"   _       _             __
"  (_)     | |           / _|
"   _ _ __ | |_ ___ _ __| |_ __ _  ___ ___
"  | | '_ \| __/ _ \ '__|  _/ _` |/ __/ _ \
"  | | | | | ||  __/ |  | || (_| | (_|  __/
"  |_|_| |_|\__\___|_|  |_| \__,_|\___\___|
" INTERFACE {{{
" <leader>ww to swap windows
Plug 'wesQ3/vim-windowswap'
" }}}
call plug#end()
endif
" }}}

source ~/.vimrc_noplugin

" JAVASCRIPT
if exists('g:loaded_plug')
vmap <c-b> :call JsBeautify()<cr>

"" GVIM
if has('gui_running')
    set guioptions-=m  "remove menu bar
    set guioptions-=T  "remove toolbar
    set guioptions-=r  "remove right-hand scroll bar
    set guioptions-=L  "remove left-hand scroll bar
    set guifont=DroidSansMonoForPowerline\ Nerd\ Font\ 11
endif

function! HasColorscheme(name)
    let pat = 'colors/'.a:name.'.vim'
    return !empty(globpath(&rtp, pat))
endfunction

let base16colorspace=256
" base 16 theme: vvv
" colorscheme base16-monokai

" "if HasColorscheme('monokai')
" "    colorscheme monokai
" "endif

" "if HasColorscheme('PaperColor')
" "    set background=light
" "    colorscheme PaperColor
" "endif

if HasColorscheme('solarized')
    let g:solarized_termcolors=256
    set background=light
    colorscheme solarized
endif

set t_Co=256

" cfg_tagbar
nmap <F8> :TagbarToggle<CR>
"" vim-airline
" cfg_airline
let g:airline_powerline_fonts = 1
" let g:airline_theme = 'base16'
let g:airline#extensions#tagbar#flags = 'f'

let g:airline_mode_map = {
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
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
" Don't show file type
let g:airline_section_x='%{airline#util#prepend(airline#extensions#tagbar#currenttag(),0)}%{airline#util#prepend("", 0)}'
" default..
let g:airline_section_z='%3p%% %#__accent_bold#%{g:airline_symbols.linenr}%4l%#__restore#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__# :%3v'
" modified, remove spaces
let g:airline_section_z='%p%%%#__accent_bold#%{g:airline_symbols.linenr}%l%#__restore#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__#:%v'
" cfg_capslock
" let g:airline#extensions#capslock#enabled = 1
let g:airline_skip_empty_sections = 1
" determine whether inactive windows should have the left section collapsed to
" only the filename of that buffer.  >
let g:airline_inactive_collapse = 1

" enable only this extensions
" let g:airline#extensions#hunks#non_zero_only = 1
" let g:airline#extensions#virtualenv#enabled = 0
" cfg_devicons
let g:webdevicons_enable_airline_statusline_fileformat_symbols = 0

"" SQL
if has("autocmd")
    autocmd BufRead *.sql set filetype=mysql
endif

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

set wildignore+=*/node_modules/*

" Supertab disable
" cfg_supertab
let g:SuperTabMappingBackward = '<nul>'

" cfg_indentline
let g:indentLine_char = '┆'
let g:vim_json_syntax_conceal = 0
let g:indentLine_concealcursor='nc'
set conceallevel=0 " was 2
let g:indentLine_noConcealCursor=""

" Python
" cfg_jedi
let g:jedi#completions_enabled = 0
let g:jedi#show_call_signatures = 0
" cfg_ale
let g:ale_linters = {
   \ 'python': ['flake8'],
   \ 'typescript': ['tslint', 'tsserver'],
   \ 'javascript': ['eslint'],
   \}
let g:airline#extensions#ale#enabled = 1
nmap ]e <Plug>(ale_next_wrap)
nmap [e <Plug>(ale_previous_wrap)
" f06a
" f071
let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_set_highlights = 0
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\   'python': ['autopep8', 'yapf']
\}

" pass
let g:flake8_show_in_file = 1

"Yank stack
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste

" RUSSIAN
highlight lCursor guifg=NONE guibg=Cyan
let g:XkbSwitchEnabled = 1

" Vim switch
" AndrewRadev/switch.vim
let g:switch_mapping = "-"

" cfg_wordmotion
let g:wordmotion_prefix = '<Leader>'

" cfg_ack
let g:ackprg = '~/.bin/search.py'
let g:ack_autoclose = 1
" cfg_ag
" let g:ag_prg = 'H0Me/.bin/search.py'

cnoreabbrev Ag Ack
cnoreabbrev Rg Ack
cnoreabbrev Agmo Ack -G \/models.py<C-b><Right><Right><Right>
cnoreabbrev Agv Ack -G \/views.py<C-b><Right><Right><Right>
cnoreabbrev Agu Ack -G \/urls.py<C-b><Right><Right><Right>
cnoreabbrev Agt Ack -G \/test_<C-b><Right><Right><Right>
cnoreabbrev Agf Ack -G \/factories.py<C-b><Right><Right><Right>
cnoreabbrev Agcm Ack class\ -w -G \/models.py<C-b><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right>

cnoreabbrev das !django-admin show_urls \| grep

let g:ackhighlight = 1
let g:ack_use_dispatch = 1
" idk
" let g:ack_qhandler = "botright copen 30"
" Use this option to automagically open the file with 'j' or 'k'.
let g:ackpreview = 1
let g:ack_use_cword_for_empty_search = 1

" cfg_caw, comments
nmap <Leader>c<Space> <Plug>(caw:hatpos:toggle)
vmap <Leader>c<Space> <Plug>(caw:hatpos:toggle)

" VUE.JS
" fix  syntax highlighting stops working randomly
" autocmd FileType vue syntax sync fromstart
" When checking for preprocessor languages, multiple syntax highlighting checks are done, which can slow down vim.
" cfg_vue
let g:vue_disable_pre_processors=1

" Html
vmap ,x :!tidy -q -i --show-errors 0 -xml<CR>

" cfg_myshitplugin
nmap <leader>bb :GetVCSLineUrl<CR>

let g:vcsurl_register = '+'

" no slowdown when using multiple cursors
function! Multiple_cursors_before()
    let b:deoplete_disable_auto_complete = 1
endfunction

function! Multiple_cursors_after()
    let b:deoplete_disable_auto_complete = 0
endfunction

" cfg_figlet
let g:figletFontDir = '~/.figlet/contributed/'
" typescript
" filetype plugin on
" set omnifunc=syntaxcomplete#Complete
if has('nvim')
  let g:node_host_prog = '/usr/local/bin/neovim-node-host'
endif
let g:AutoPairsShortcutJump = '<S-tab>'

" cfg_comfortablemotion
let g:comfortable_motion_friction = 600.0
let g:comfortable_motion_air_drag = 1.0
" cfg_language_client
function LC_maps()
  if has_key(g:LanguageClient_serverCommands, &filetype)
    nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<cr>
    nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
    nnoremap <buffer> <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
  endif
endfunction

" npm install vue-language-server -g
let g:LanguageClient_serverCommands = {
    \ 'vue': ['vls']
    \ }


autocmd FileType * call LC_maps()

" cfg_ultisnips
let g:UltiSnipsExpandTrigger="<c-b>"
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"

" cfg_tsuquyomi
let g:tsuquyomi_disable_quickfix=1
" autocmd InsertLeave,BufWritePost *.ts,*.tsx call tsuquyomi#asyncGeterr()
endif

let g:user_emmet_settings = {
\  'typescript' : {
\      'extends' : 'jsx',
\  },
\}

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gu <Plug>(coc-references)

" cfg_switch
let g:switch_custom_definitions =
    \ [
    \   ['!==', '===']
    \ ]

" cfg_yankstack
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste

" cfg_sideways
nnoremap <leader><c-h> :SidewaysLeft<cr>
nnoremap <leader><c-l> :SidewaysRight<cr>

" I go hard
nnoremap jj <nop>
nnoremap kk <nop>
nnoremap hh <nop>
nnoremap ll <nop>

" cfg_markdown
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0


if has('nvim')
  let g:python_host_prog = "~/.pyenv/versions/neovim2/bin/python"
  let g:python3_host_prog = "~/.pyenv/versions/neovim3/bin/python"
endif

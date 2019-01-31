syntax sync fromstart
" gf - go to file
set suffixesadd=.vue,.js
set includeexpr=substitute(v:fname,'^\\/','','g')
set path=$PWD/.,$PWD/src

let b:delimitMate_matchpairs = "(:),[:],{:}"

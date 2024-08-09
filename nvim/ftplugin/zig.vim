" Vim filetype plugin
" Language:   Zig
" Maintainer: Amelia Clarke

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

" Formatting settings.
setlocal formatoptions-=t formatoptions+=croql/

" Zig recommended style.
if !exists("g:zig_recommended_style") || g:zig_recommended_style != 0
  setlocal expandtab
  setlocal shiftwidth=4
  setlocal softtabstop=4
  setlocal textwidth=100
endif

" Miscellaneous.
setlocal comments=://!,:///,://,:\\\\
setlocal commentstring=//\ %s
setlocal iskeyword+=@-@
setlocal suffixesadd=.zig

" Locate standard library.
if !exists("g:zig_std_dir") && exists("*json_decode") && executable("zig")
  silent let s:env = system("zig env")
  if v:shell_error == 0
    let g:zig_std_dir = json_decode(s:env)["std_dir"]
  endif
  unlet! s:env
endif

" Add standard library to path.
if exists("g:zig_std_dir")
  execute "setlocal path+=" .. g:zig_std_dir
endif

compiler zig

let b:undo_ftplugin = "setl cms< com< et< fo< isk< pa< sts< sua< sw< tw<"

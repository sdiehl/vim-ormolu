if !exists("g:ormolu_command")
  let g:ormolu_command = "ormolu"
endif
if !exists("g:ormolu_options")
  let g:ormolu_options = [""]
endif

function! s:OverwriteBuffer(output)
  let winview = winsaveview()
  silent! undojoin
  normal! gg"_dG
  call append(0, split(a:output, '\v\n'))
  normal! G"_dd
  call winrestview(winview)
endfunction

function! s:OrmoluHaskell()
  if executable(g:ormolu_command)
    call s:RunOrmolu()
  elseif !exists("s:exec_warned")
    let s:exec_warned = 1
    echom "ormolu executable not found"
  endif
endfunction

function! s:RunOrmolu()
  let output = system(g:ormolu_command . " " . join(g:ormolu_options, ' ') . " " . bufname("%"))
  if v:shell_error != 0
    echom output
  else
    "echom output
    call s:OverwriteBuffer(output)
    write
  endif
endfunction

augroup ormolu-haskell
  autocmd!
  autocmd BufWritePost *.hs call s:OrmoluHaskell()
augroup END

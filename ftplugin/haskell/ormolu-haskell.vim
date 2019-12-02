if !exists("g:ormolu_command")
  let g:ormolu_command = "ormolu"
endif
if !exists("g:ormolu_options")
  let g:ormolu_options = [""]
endif
if !exists("b:ormolu_disable")
  let b:ormolu_disable = 0
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

function! s:OrmoluSave()
  if b:ormolu_disable == 1
    write
  else
    call s:OrmoluHaskell()
  endif
endfunction

function! s:RunOrmolu()
  let output = system(g:ormolu_command . " " . join(g:ormolu_options, ' ') . " " . bufname("%"))
  if v:shell_error != 0
    echom output
  else
    call s:OverwriteBuffer(output)
    write
  endif
endfunction

function! RunOrmolu()
  call s:OrmoluHaskell()
endfunction

function! ToggleOrmolu()
  if b:ormolu_disable == 1
    let b:ormolu_disable = 0
    echo "Ormolu formatting enabled."
  else
    let b:ormolu_disable = 1
    echo "Ormolu formatting disabled."
  endif
endfunction

function! DisableOrmolu()
    let b:ormolu_disable = 1
    echo "Ormolu formatting disabled."
endfunction

function! EnableOrmolu()
    let b:ormolu_disable = 0
    echo "Ormolu formatting enabled."
endfunction

augroup ormolu-haskell
  autocmd!
  autocmd BufWritePost * if &filetype == 'haskell' | call s:OrmoluSave() | endif
augroup END

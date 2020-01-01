if !exists("g:ormolu_command")
  let g:ormolu_command = "ormolu"
endif
if !exists("g:ormolu_options")
  let g:ormolu_options = [""]
endif
if !exists("g:ormolu_disable")
  let g:ormolu_disable = 0
endif
if !exists("b:ormolu_disable")
  " Inherit buffer level flag from global flag (default 0)
  let b:ormolu_disable = g:ormolu_disable
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
  if (b:ormolu_disable == 1)
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

function! OrmoluBlock()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    let length = 1 + (line_end-line_start)
    let output = system(g:ormolu_command . " " . join(g:ormolu_options, ' '), lines)
    let formatted = split(output, '\v\n')

    if v:shell_error != 0
      echom output
    else

      if length > len(formatted)
        let max = line_end - 1
      else
        let max = (line_start + len(formatted)) - 1
      endif

      " If the length of outputted code is longer than visual block append empty
      " lines to fill
      if len(formatted) > length
        let c = 0
        while c < (len(formatted) - length)
          call append(line_end, "")
          let c = c+1
        endwhile
      endif

      " If the length of outputted code is longer than visual block delete lines
      if len(formatted) < length
        let c = 0
        while c < (length - len(formatted))
          normal! dd
          let c = c+1
        endwhile
      endif

      " Empty the visual block
      let currentLine=line_start
      while currentLine <= line_end
        call setline(currentLine, "")
        let currentLine = currentLine + 1
      endwhile

      " Replace with ormolu output
      let currentLine=line_start
      let ix=0
      while currentLine <= max
        "echom "Replacing"
        call setline(currentLine, formatted[ix])
        let currentLine = currentLine + 1
        let ix = ix + 1
      endwhile
    endif
endfunction

function! RunOrmolu()
  call s:OrmoluHaskell()
endfunction

function! ToggleOrmolu()
  if b:ormolu_disable == 1
    let b:ormolu_disable = 0
    echo "Ormolu formatting enabled for " . bufname("%")
  else
    let b:ormolu_disable = 1
    echo "Ormolu formatting disabled for " . bufname("%")
  endif
endfunction

function! DisableOrmolu()
    let b:ormolu_disable = 1
    echo "Ormolu formatting disabled for " . bufname("%")
endfunction

function! EnableOrmolu()
    let b:ormolu_disable = 0
    echo "Ormolu formatting enabled for " . bufname("%")
endfunction

augroup ormolu-haskell
  autocmd!
  autocmd BufWritePost *.hs call s:OrmoluSave()
augroup END

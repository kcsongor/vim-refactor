command! -nargs=0 -complete=tag FindAllPrompt
  \ silent! call s:find_all_uses()

command! -nargs=1 -complete=tag FindAll
  \ silent! call s:find_all_uses(<q-args>)

command! -nargs=1 -complete=tag FindAllNewTab
  \ silent! call refactor#find_all_tab(<q-args>)

command! -nargs=1 -complete=tag FindCwd
  \ silent! call s:find_all_uses(<q-args>, getcwd())

command! ToggleRefactoring
  \ call s:toggle_refactoring()

" Refactoring mode {{{
if (!exists('g:refactoring'))
  let g:refactoring = 0
endif

function! refactor#refactoring_mode()
  if (g:refactoring != 0)
    return "Refactoring [" . g:refactoring . "]"
  else
    return ""
  endif
endfunction

function! s:toggle_refactoring()
  if (g:refactoring != 0)
    call s:stop_refactoring()
  else
    call s:start_refactoring()
  endif
endfunction

function! s:start_refactoring()
  let g:refactoring = strftime("%H:%M")
  mksession! Refactoring.vim
endfunction

function! s:stop_refactoring()
  :%bd
  source Refactoring.vim
  let g:refactoring = 0
endfunction

"}}}

function! refactor#find_all_tab(...)
  let word = 0 < a:0 ? a:1 : inputdialog("Word to search for: ")
  $tabe %
  if (exists('g:tabbar_loaded'))
    tabbar#rename_current_tab("[Uses of " . word . "]")
  endif
  call s:find_all_uses(word)
  vertical topleft lopen
  vertical resize 50
  set winfixwidth
endfunction

function! s:find_all_uses(...)
  silent! call matchdelete(66)
  let word = 0 < a:0 ? a:1 : inputdialog("Word to search for: ")
  let in_dir = ""
  if (a:0 > 1)
    let in_dir = " -- ".a:2
  endif
  exe "Glgrep! -w " . shellescape(word) . in_dir
  silent! ldo call matchadd('FoundGroup', '\<' . word . '\>', 100, 66)
endfunction

function! refactor#replace_all_word(...)
  silent! call matchdelete(66)
  let word = 0 < a:0 ? a:1 : inputdialog("Word to replace: ")
  let to = 1 < a:0 ? a:2 : inputdialog("Replace (" . word . ") with: ")
  $tabe %
  if (exists('g:tabbar_loaded'))
    tabbar#rename_current_tab("[Uses of " . word . "]")
  endif
  " Check for clashes
  if (a:0 > 2)
    silent! call s:find_all_uses(to, a:3)
  else
    silent! call s:find_all_uses(to)
  endif
  let loclist = getloclist(bufwinnr(bufname('.')))
  if (len(loclist) > 0)
    echoe to . " already exists"
    lopen
    return
  endif
  """""""""""""""
  if (a:0 > 2)
    silent! call s:find_all_uses(word, a:3)
  else
    silent! call s:find_all_uses(word)
  endif
  silent! exe "ldo %s/\\<" . word . "\\>/" . to . "/gcI \| update"
endfunction

"function! ReplaceAll(...)
"  let str = 0 < a:0 ? a:1 : inputdialog("String to replace: ")
"  let to = 1 < a:0 ? a:2 : inputdialog("Replace (" . str . ") with: ")
"  let in_dir = ""
"  if (a:0 > 2)
"    let in_dir = " -- ".a:3
"  endif
"  exe "Glgrep! " . shellescape(str) . in_dir
"  exe "ldo %s/" . str . "/" . to . "/gcI \| update"
"endfunction

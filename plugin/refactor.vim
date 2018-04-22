command! -nargs=1 -complete=tag FindAll
  \ silent! call FindSomeUsage(<q-args>)

command! -nargs=1 -complete=tag FindCwd
  \ silent! call FindSomeUsage(<q-args>, getcwd())

function! FindSomeUsage(...)
  silent! call matchdelete(66)
  let word = 0 < a:0 ? a:1 : inputdialog("Word to search for: ")
  hi FoundGroup ctermbg=blue ctermfg=white
  let in_dir = ""
  if (a:0 > 1)
    let in_dir = " -- ".a:2
  endif
  exe "Glgrep! -w " . shellescape(word) . in_dir
  silent! ldo call matchadd('FoundGroup', '\<' . word . '\>', 100, 66)
endfunction

function! ReplaceAllWord(...)
  silent! call matchdelete(66)
  let word = 0 < a:0 ? a:1 : inputdialog("Word to replace: ")
  let to = 1 < a:0 ? a:2 : inputdialog("Replace (" . word . ") with: ")
  " Check for clashes
  if (a:0 > 2)
    silent! call FindSomeUsage(to, a:3)
  else
    silent! call FindSomeUsage(to)
  endif
  let loclist = getloclist(bufwinnr(bufname('.')))
  if (len(loclist) > 0)
    echoe to . " already exists"
    lopen
    return
  endif
  """""""""""""""
  if (a:0 > 2)
    silent! call FindSomeUsage(word, a:3)
  else
    silent! call FindSomeUsage(word)
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

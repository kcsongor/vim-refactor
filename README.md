# vim-refactor

## Useful mappings
Replace word under cursor in the file
```vim
nnoremap <leader>% :%s/\<<C-r><C-w>\>//gI\|norm``<left><left><left><left><left><left><left><left><left><left>
```
![replace_g](replace_g.gif)

Replace word under cursor in last selection
```vim
nnoremap <leader>< :'<,'>s/\<<C-r><C-w>\>//gI\|norm``<left><left><left><left><left><left><left><left><left><left>
```
![replace_g](replace_g.gif)

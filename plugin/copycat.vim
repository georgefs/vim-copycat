" ----------------------------------
"  default settings for vim-copycat
" ----------------------------------

let s:settings = {
    \ 'default_clipboard': "'copycat'",
    \ 'overwrite_ctrlkeys': 1
    \}

" eval if any global setting exists
for [key, val] in items(s:settings)
    if !exists('g:copycat#'.key)
        exe 'let g:copycat#'.key.' = '.val
    endif
endfor


" -------------------------------------------------------
"  Transfering content between copycat and VIM registers
" -------------------------------------------------------


" save value to specified VIM register
function! s:save_to_register(registername, value)

python << EOF
import vim

registername = vim.eval('a:registername')
value = vim.eval('a:value')

if registername not in ["\"", "-", "+", "*", "/"]:
    vim.command('return 0')
elif registername not in [str(i) for i in range(10)]:
    vim.command('return 0')

vim.command("let @%s = \"%s\"" % (registername, value))

EOF

endfunction

" save value to specified copycat clipboard
function! s:save_to_copycat(clipboard_name, value)

python << EOF
import vim
import copycat

clipboard_name = vim.eval('a:clipboard_name')
value = vim.eval('a:value')
if clipboard_name == 'default':
    clipboard_name = None

copycat.copy(value=value, name=clipboard_name)
EOF

endfunction

function! s:copy(named)
    
    if a:named == 1
        let reg_name = input("copycat --name :")
    else
        let reg_name = ''
    endif

python << EOF
    import vim
    import copycat
    reg_name = vim.eval('reg_name')
    value = vim.eval('@0')
    copycat.copy(name=reg_name, value=value)
EOF

endfunction

function! s:paste(named)

    if a:named == 1
        let reg_name = input("copycat --name :")
    else
        let reg_name = ''
    endif


python << EOF
    import vim
    import copycat
    import re

    reg_name = vim.eval('reg_name')
    tmp = vim.eval('@a')
    data = copycat.paste()
    data = re.sub(r'([\"\\])', r'\\\1', data)
    vim.command('let @a=\"{}\"'.format(data))
    vim.command('norm \"ap')
    data = re.sub(r'([\"\\])', r'\\\1', tmp)
    vim.command('let @a=\"{}\"'.format(data))
EOF

endfunction


function! s:delete()

let reg_name = input("copycat --delete --name :")

python << EOF
    import vim
    import copycat
    reg_name = vim.eval('reg_name')
    data = copycat.delete(reg_name)
EOF

endfunction

function! s:list()

python << EOF
    import copycat
    copycat.view()
EOF

endfunction

if exists('g:copycat#overwrite_ctrlkeys')
    vmap <silent> <C-c>c y:call <SID>copy(0)<CR>
    imap <silent> <C-c>p <ESC>y:call <SID>paste(0)<CR>
    nmap <silent> <C-c>l :call <SID>list()<CR>
    nmap <silent> <C-c>d :call <SID>delete()<CR>

    vmap <silent> <C-c>C y:call <SID>copy(1)<CR>
    imap <silent> <C-c>P <ESC>y:call <SID>paste(1)<CR> 
endif

" vim:set et sw=4:

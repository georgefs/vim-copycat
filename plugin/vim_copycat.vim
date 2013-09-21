function! s:copy()

let reg_name = input("copycat --name :")
python << EOF
import vim
import copycat
reg_name = vim.eval('reg_name')
value = vim.eval('@0')
copycat.copy(name=reg_name, value=value)
EOF

endfunction


function! s:paste()

let reg_name = input("copycat --paste --name :")
python << EOF
import vim
import copycat
reg_name = vim.eval('reg_name')
data = copycat.paste()
vim.command("normal a"+data)
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

vmap <silent> <C-c>c y:call <SID>copy()<CR>
imap <silent> <C-c>p <ESC>y:call <SID>paste()<CR>p 
nmap <silent> <C-c>l :call <SID>list()<CR>
nmap <silent> <C-c>d :call <SID>delete()<CR>

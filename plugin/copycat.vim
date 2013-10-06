" ----------------------------------
"
"  default settings for vim-copycat
" reg vim reg which is share with copycat '' as default as @"
" clip copycat reg name which is share with vim '' as default as system clip 
" ----------------------------------
let s:settings = {
    \ 'reg': '',
    \ 'clip': '',
    \ 'overwrite_ctrlkeys': 1,
    \ 'auto_sync': 0,
    \}


" ----------------------------------
"
"  initialize
"
" ----------------------------------



python << EOF
import sys
import vim
sys.path.append(vim.eval('expand("<sfile>:p:h:h")'))
import copycat_plugin
EOF


" eval if any global setting exists
for [key, val] in items(s:settings)
    if !exists('g:copycat#'.key)
        let g:copycat#{key} = val
    endif
endfor


if exists('g:copycat#overwrite_ctrlkeys') && g:copycat#overwrite_ctrlkeys == 1
    vmap <silent> <C-c>c y:call <SID>copy(0, g:copycat#reg)<CR>
    imap <silent> <C-c>p <ESC>y:call <SID>paste(0, g:copycat#reg)<CR>
    nmap <silent> <C-c>l :call <SID>list()<CR>
    nmap <silent> <C-c>d :call <SID>delete()<CR>

    vmap <silent> <C-c>C y:call <SID>copy(1, g:copycat#reg)<CR>
    imap <silent> <C-c>P <ESC>y:call <SID>paste(1, g:copycat#reg)<CR> 
endif

if exists('g:copycat#auto_sync') && g:copycat#auto_sync == 1
    vn <silent> y y:call <SID>push_into_clip(@", g:copycat#clip)<CR>
    nn <silent> yy yy:call <SID>push_into_clip(@", g:copycat#clip)<CR>
    nn <silent> Y Y:call <SID>push_into_clip(@", g:copycat#clip)<CR>

    vn <silent> d d:call <SID>push_into_clip(@", g:copycat#clip)<CR>
    nn <silent> dd dd:call <SID>push_into_clip(@", g:copycat#clip)<CR>
    nn <silent> D D:call <SID>push_into_clip(@", g:copycat#clip)<CR>

    vn <silent> c c<ESC>:call <SID>push_into_clip(@", g:copycat#clip)<CR>a
    nn <silent> cc cc<ESC>:call <SID>push_into_clip(@", g:copycat#clip)<CR>a
    nn <silent> C C<ESC>:call <SID>push_into_clip(@", g:copycat#clip)<CR>a

    nn <silent> p :let @"=<SID>pop_from_clip(g:copycat#clip)<CR>p
endif



" ----------------------------------
"
"  vim utils
"
" ----------------------------------

function! s:get_clip(run)
    if a:run
        return input("copycat clip name:")
    elseif exists('g:copycat#clip') 
        return g:copycat#clip
    else
        return ""
    endif
endfunction


function! s:safe_copy()
    let l:tmp=@"
    norm y
    let l:result=@"
    let @"=l:tmp
    return l:result
endfunction


function! s:safe_paste(value)
    let l:tmp=@"
    let @"=a:value
    norm p
    let @"=l:tmp
endfunction


" ----------------------------------
"
"  main function
"
" ----------------------------------
" push value into copycat clip
"
" @value value which context push to copycat
" @name copycat reg name where value save to
" ----------------------------------
function! s:push_into_clip(value, reg_name)

python << EOF
copycat_plugin.copy(value="a:value", name="a:reg_name")
EOF

endfunction


" ----------------------------------
" pop value from copycat clip
"
" @name copycat reg name
" @reg_name vim reg name, where copycat value into
" ----------------------------------
function! s:pop_from_clip(name)
python <<EOF
copycat_plugin.paste(name="a:name", result="l:result")
EOF
return l:result
endfunction


" ----------------------------------
" copy
"
" @named boolean on/off copycat name set
" @reg_name sync value to reg_name
" ----------------------------------
function! s:copy(named, reg_name)
    let l:reg_name = s:get_clip(a:named)
    let l:value = s:safe_copy()
    call s:push_into_clip(l:value, l:reg_name)

    if a:reg_name!=""
        let {a:reg_name} = @"
    endif

endfunction


" ----------------------------------
" paste
"
" @named boolean on/off copycat name set
" @reg_name sync value to reg_name
" ----------------------------------
function! s:paste(named, reg_name)
    let l:name = s:get_clip(a:named)

    let l:result = s:pop_from_clip(l:name)

    if a:reg_name!=""
        let {a:reg_name} = @"
    endif

    call s:safe_paste(l:result)

endfunction


" ----------------------------------
" delete
" ----------------------------------
function! s:delete()

let l:reg_name = s:get_clip(1)

python << EOF
copycat_plugin.delete(name=vim.eval('l:reg_name'))
EOF

endfunction


" ----------------------------------
" list
" ----------------------------------
function! s:list()

python << EOF
copycat_plugin.list()
EOF

endfunction


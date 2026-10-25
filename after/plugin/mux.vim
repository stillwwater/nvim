if empty($MUX) || exists('g:loaded_mux')
    finish
endif
let g:loaded_mux = 1

set showtabline=0

function! s:send(cmd)
    call chansend(v:stderr, "\x1b]" . a:cmd . "\x07")
endfunction

function! s:navigate(dir)
    let win = winnr()
    execute 'wincmd ' . a:dir
    if winnr() == win
        call s:send('mux;focus;' . a:dir)
    endif
endfunction

function! s:color()
    let m = matchlist(v:termresponse, '\]1\([01]\);rgb:\(\x\x\)\x*/\(\x\x\)\x*/\(\x\x\)')
    if !empty(m)
        execute 'hi Normal gui' . (m[1] ? 'bg' : 'fg') . '=#' . m[2] . m[3] . m[4]
    endif
endfunction

for [s:dir, s:key] in [['h', 'h'], ['j', 'j'], ['k', 'k'], ['l', 'l'],
        \ ['h', '<Left>'], ['j', '<Down>'], ['k', '<Up>'], ['l', '<Right>']]
    execute 'nnoremap <silent><C-w>' . s:key . ' <Cmd>call <SID>navigate("' . s:dir . '")<CR>'
endfor

autocmd TermResponse * call s:color()
autocmd VimEnter,VimResume * call s:send('mux;grab') | call s:send('10;?') | call s:send('11;?')

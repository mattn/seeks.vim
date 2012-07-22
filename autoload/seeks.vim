if !exists('g:seeks_node')
    let g:seeks_node = 'http://seeks.fr'
endif
if !exists('g:seeks_max_results')
    let g:seeks_max_results = 5
endif

function! seeks#Find(...)
    let query = a:0 > 0 ? a:1 : ''
    if query == ''
        call inputsave()
        let query = input('Search: ')
        call inputrestore()
    endif
    call seeks#Search(query)
endfunction

function! seeks#Search(query)
    echo "Searching ..."

    let query = expand(a:query)
    let url = g:seeks_node . '/search?output=json&q=' . webapi#http#encodeURI(query)
    let json = webapi#http#get(url)
    let results = webapi#json#decode(json.content)

    let i = 0
    for snippet in results.snippets
        if g:seeks_max_results > 0 && i > g:seeks_max_results
            break
        endif
        let @z = @z . snippet.url . "\n"
            \ . "\t" . snippet.title . "\n\n"
            \ . "\t" . snippet.summary . "\n"
        let i = i + 1
    endfor

    call s:OpenWindow()
endfunction

function! s:OpenWindow()
    call s:CreateWindow()
    call s:PopulateWindow()
endfunction

function! s:CreateWindow()
    let winnr = bufwinnr('-seeks-')
    if winnr == -1
        execute 'botright sp -seeks-'
        call s:InitWindow()
    else
        exe winnr . 'wincmd w'
    endif
endfunction

function! s:InitWindow()
    setlocal readonly
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted
    setlocal nomodifiable
    setlocal nolist
    setlocal nonumber
    setlocal nowrap
    setlocal textwidth=0
    setlocal nocursorline
    setlocal nocursorcolumn
    setlocal nospell
    setlocal foldmethod=indent
    setlocal foldlevel=0
endfunction

function! s:PopulateWindow()
    setlocal modifiable
    setlocal noreadonly

    " Delete previous content
    normal! ggdG
    " Paste new content
    normal! "zPgg
    " Fold
    normal! zm

    setlocal nomodifiable
    setlocal readonly

    let @z = ""
endfunction

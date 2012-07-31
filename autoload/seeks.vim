let g:seeks_node = get(g:, 'seeks_node', 'http://seeks.fr')
let g:seeks_max_results = get(g:, 'seeks_max_results', 5)
let g:seeks_append_results = get(g:, 'seeks_append_results', 0)

function! seeks#Find(...)
    let query = a:0 > 0 ? expand(a:1) : ''
    if query == ''
        call inputsave()
        let query = input('Search: ')
        call inputrestore()
    endif
    call s:Search(query)
endfunction

function! s:Search(query)
    redraw
    echo "Searching ..."

    let url = g:seeks_node . '/search?output=json&q=' . webapi#http#encodeURI(a:query)
    let json = webapi#http#get(url)
    let results = webapi#json#decode(json.content)

    let i = 0
    let @z = "Results for '" . a:query . "':\n"
    for snippet in results.snippets
        if g:seeks_max_results > 0 && i > g:seeks_max_results
            break
        endif
        let @z = @z . "\t" . snippet.url . "\n"
            \ . "\t\t" . snippet.title . "\n\n"
            \ . "\t\t" . snippet.summary . "\n"
        let i = i + 1
    endfor
    let @z = @z . "\n"

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

    normal! gg
    if g:seeks_max_results == 0
        " Delete previous content
        normal! dG
    endif
    " Paste new content
    normal! "zP
    " Fold
    silent! normal! zmjzo

    setlocal nomodifiable
    setlocal readonly

    let @z = ""
endfunction

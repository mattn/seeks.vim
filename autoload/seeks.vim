if !exists('g:seeks_node')
    let g:seeks_node = 'http://seeks.fr'
endif
if !exists('g:seeks_max_results')
    let g:seeks_max_results = 5
endif

function! seeks#Search(query)
    let url = g:seeks_node . '/search?output=json&q=' . webapi#http#encodeURI(a:query)
    let json = webapi#http#get(url)
    let results = webapi#json#decode(json.content)

    let i = 0
    for snippet in results.snippets
        if g:seeks_max_results > 0 && i > g:seeks_max_results
            break
        endif
        echo snippet.url . '|' . snippet.title
        let i = i + 1
    endfor
endfunction

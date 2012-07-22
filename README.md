# seeks.vim

Make a seeks search inside vim

## Requirements

    * https://github.com/mattn/webapi-vim

## Installation

I recommend installation with [pathogen.vim](https://github.com/tpope/vim-pathogen).

    $ cd ~/.vim/bundle
    $ git clone https://github.com/sanpii/seeks.vim.git

## Usage

    nnoremap <silent> <C-K> :call seeks#Search('<cword>')<CR>

## Configuration

    let g:seeks_node = 'http://seeks.fr'
    let g:seeks_max_results = 5

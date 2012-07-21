# seeks.vim

## Description

Make a seeks search inside vim

## Installation

I recommend installation with [pathogen.vim](https://github.com/tpope/vim-pathogen).

    $ cd ~/.vim/bundle
    $ git clone https://github.com/mattn/webapi-vim.git
    $ git clone https://github.com/sanpii/seeks.vim.git

## Configuration

    let g:seeks_node = 'http://seeks.fr'
    let g:seeks_max_results = 5

## Usage

    :call seeks#Search('vim')

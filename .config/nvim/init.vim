" Visual appearance

" Get the right colours, this makes ALL the difference
set termguicolors

" I've got a gruvbox and I'm gonna use it!

" Toggle for light or dark modes
set background=dark
"set background=light

" Other gruvbox settings
let g:gruvbox_bold=1
let g:gruvbox_italic=0
let g:gruvbox_underline=1
let g:gruvbox_undercurl=1
"let g:gruvbox_termcolors=256
let g:gruvbox_contrast_dark='hard' " Options are soft, medium or hard	
"let g:gruvbox_contrast_light=hard " Options are soft, medium or hard	
let g:gruvbox_hls_cursor='orange' " Options are any colour in gruvbox palette, default is orange
let g:gruvbox_number_column='none' " Options are any colour in gruvbox palette, default is none 
let g:gruvbox_sign_column='bg1' " Options are any colour in gruvbox palette, default is bg1
let g:gruvbox_color_column='bg1' " Options are any colour in gruvbox palette, default is bg1
let g:gruvbox_vert_split='bg0' " Options are any colour in gruvbox palette, default is bg0
let g:gruvbox_italicize_comments=1
let g:gruvbox_italicize_strings=0
let g:gruvbox_invert_selection=1
let g:gruvbox_invert_signs=0
let g:gruvbox_invert_indent_guides=0
let g:gruvbox_invert_tabline=0
let g:gruvbox_improved_strings=0
let g:gruvbox_improved_warnings=0
let g:gruvbox_guisp_fallback='none'

" Airline


" General settings
set number
set numberwidth=4
set shiftwidth=4
set tabstop=4

set encoding=utf-8

" Syntax highlighting

set syntax=ON

" Apache



" Desktop .ini files
let b:enforce_freedesktop_standard=1

" HTML
let g:html_use_xhtml=1 " Convert to XHTML

" Lua
let lua_version=5
let lua_subversion=1




" Python
let python_highlight_all=1

" Shell
let g:is_bash=1
let g:sh_fold_enabled=1

" SQL
let g:sql_type_default='mysql'

" XML


" COC settings

" Set correct commenting
autocmd FileType json syntax match Comment +\/\/.\+$+




" Set language providers

" Node.js
let g:coc_node_path = '/usr/bin/node'

" Python2 not installed on Fedora by default
let g:loaded_python_provider=0

" Python3 
let g:python3_host_prog = '~/.virtualenvs/py3nvim/bin/python'

" Ruby provider, is this necessary? TODO


" 
augroup Fedora
  autocmd!
  " RPM spec file template
  autocmd BufNewFile *.spec silent! 0read /usr/share/nvim/template.spec
augroup END



" Plugins via vim-plug, saved to default neovim location
call plug#begin(stdpath('data') . '/plugged')

" Visual appearance

" Theme colour scheme 
Plug 'morhetz/gruvbox'

" Statusline
Plug 'vim-airline/vim-airline'

" Statusline themes
Plug 'vim-airline/vim-airline-themes'

" Python development

" Code completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" PEP8 syntax checking
Plug 'nvie/vim-flake8'

" Code folding
Plug 'tmhedberg/simplyfold'


call plug#end()

"============================================================================
" FILE: plugin/taggedtemplate.vim
" AUTHOR: Quramy <yosuke.kurami@gmail.com>
" ADAPTATION BY: cdata <chris@scriptolo.gy>
"============================================================================

scriptencoding utf-8

if exists('g:loaded_tagged_template')
  finish
endif
let g:loaded_tagged_template = 1
let s:save_cpo = &cpo
set cpo&vim

echom 'hi'
"command! -nargs=2 -complete=custom,filetype TemplateTagSyntax : call taggedtemplate#setSyntax(<f-args>)
"command! TemplateTagClear : call taggedtemplate#clear()

let &cpo = s:save_cpo
unlet s:save_cpo

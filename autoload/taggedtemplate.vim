"============================================================================
" FILE: autoload/taggedtemplate.vim
" AUTHOR: Quramy <yosuke.kurami@gmail.com>
" ADAPTATION BY: cdata <chris@scriptolo.gy>
"============================================================================

scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! s:loadSyntax(group, filetype)
  " syntax save
  if exists('b:current_syntax')
    let s:current_syntax = b:current_syntax
    unlet b:current_syntax
  endif

  "echom 'Loading syntax include @'.a:group.' syntax/'.a:filetype.'.vim'
  execute 'syntax include @'.a:group.' syntax/'.a:filetype.'.vim'

  try
    execute 'syntax include @'.a:group.' after/syntax/'.a:filetype.'.vim'
  catch
  endtry

  " syntax restore
  if exists('s:current_syntax')
    let b:current_syntax=s:current_syntax
  else
    unlet b:current_syntax
  endif
endfunction

function! s:taggedTemplateRegion(filetype)
  return 'taggedTemplateString'.toupper(a:filetype)
endfunction

function! s:taggedTemplateGroup(filetype)
  return 'taggedTemplateContent'.toupper(a:filetype)
endfunction

function! s:taggedTemplateExpression(filetype)
  return 'taggedTemplateExpression'.toupper(a:filetype)
endfunction

function! s:setTagRegionSyntax(tag, filetype)
  let region = s:taggedTemplateRegion(a:filetype)
  let group = s:taggedTemplateGroup(a:filetype)

  let start = '+'.a:tag.'`+'
  let end = '+`+'
  let skip = '"\(\\`\|\${[^}]*`\|`\(.*\(\${\)\@!.*\)*}\)"'

  call s:loadSyntax(group, a:filetype)

  execute 'syntax region '.region.' matchgroup=taggedTemplateTicks start='.start.' skip='.skip.' end='.end.' keepend contains=@'.group.' containedin=@jsExpression'
endfunction

function! s:setTagExpressionSyntax(filetype)
  let region = s:taggedTemplateRegion(a:filetype)
  let expression = s:taggedTemplateExpression(a:filetype)

  execute 'syntax region '.expression.' matchgroup=taggedTemplateBraces start=+${+ end=+}+ keepend contains=@jsExpression containedin='.region
endfunction

function! taggedtemplate#setSyntax(tag, filetype)
  call s:setTagRegionSyntax(a:tag, a:filetype)
  call s:setTagExpressionSyntax(a:filetype)
endfunction

function! taggedtemplate#applySyntaxMap()
  if exists('g:taggedtemplate#syntaxApplied')
    return
  endif

  let g:taggedtemplate#syntaxApplied = 1

  "echom 'Applying syntax map'
  if exists('g:taggedtemplate#tagSyntaxMap')
    for [tag, filetype] in items(g:taggedtemplate#tagSyntaxMap)
      "echom tag.' => '.filetype.' # '.&ft
      call taggedtemplate#setSyntax(tag, filetype)
      unlet tag filetype
    endfor
  endif

  highlight link taggedTemplateTicks Type
  highlight link taggedTemplateBraces Comment
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo


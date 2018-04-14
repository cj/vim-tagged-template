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

  execute 'syntax region '.region.' matchgroup=taggedTemplateTicks start='.start.' skip='.skip.' end='.end.' keepend contains=@'.group
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

"call birbscript#setSyntax('html', 'html')
"call birbscript#setSyntax('md', 'markdown')

let &cpo = s:save_cpo
unlet s:save_cpo

"#### TemplateSyntax

"function! s:tmplSyntaxGroup(filetype)
  "let ft = toupper(a:filetype)
  "return 'JavaScriptPrettyTemplateCodeGroup'.ft
"endfunction

"function! s:tmplSyntaxRegion(filetype)
  "let ft = toupper(a:filetype)
  "return 'JavaScriptPrettyCodeRegion'.ft
"endfunction

"function! jspretmpl#loadOtherSyntax(filetype)
  "let group = s:tmplSyntaxGroup(a:filetype)

  "" syntax save
  "if exists('b:current_syntax')
    "let s:current_syntax = b:current_syntax
    "unlet b:current_syntax
  "endif

  "execute 'syntax include @'.group.' syntax/'.a:filetype.'.vim'

  "" syntax restore
  "if exists('s:current_syntax')
    "let b:current_syntax=s:current_syntax
  "else
    "unlet b:current_syntax
  "endif

  "return group
"endfunction

"function! jspretmpl#applySyntax(filetype, startCondition)
  "let group = s:tmplSyntaxGroup(a:filetype)
  "let region = s:tmplSyntaxRegion(a:filetype)
  "let b:jspre_current_ft = a:filetype
  "if &ft == 'javascript' || &ft == 'typescript' || &ft == 'jsx' || &ft == 'javascript.jsx'
    "if strlen(a:startCondition)
      "let regexp_start = a:startCondition
    "else
      "let regexp_start = '\w*`'
    "endif
    "let regexp_skip = '\(\\`\|\${[^}]*`\|`\(.*\(\${\)\@!.*\)*}\)'
    "let regexp_end = '`'
    "let group_def = 'start="'.regexp_start.'" skip="'.regexp_skip.'" end="'.regexp_end.'"'
    "execute 'syntax region '.region.' matchgroup=EcmaScriptTemplateStrings '.group_def.' keepend contains=@'.group.' containedin=jsTaggedTemplate'
  "elseif &ft == 'coffee' || &ft == 'dart'
    "let regexp_start = '"""'
    "let regexp_end = '"""'
    "let group_def = 'start=+'.regexp_start.'+ end=+'.regexp_end.'+'
    "execute 'syntax region '.region.' matchgroup=CoffeeScriptTemplateStringsDouble '.group_def.' keepend contains=@'.group

    "let regexp_start = "'''"
    "let regexp_end = "'''"
    "let group_def = 'start=+'.regexp_start.'+ end=+'.regexp_end.'+'
    "execute 'syntax region '.region.' matchgroup=CoffeeScriptTemplateStringsSingle '.group_def.' keepend contains=@'.group
  "else
    "return
  "endif

"endfunction

"let s:rule_map = {}
"function! jspretmpl#addRule(filetype, startCondition)
  "if !strlen(a:startCondition)
    "return
  "endif
  "let s:rule_map[a:filetype] = a:startCondition
"endfunction

"function! jspretmpl#register_tag(tagname, filetype)
  "call jspretmpl#addRule(a:filetype, a:tagname.'`')
"endfunction

"function! jspretmpl#loadAndApply(...)
  "for k in keys(s:rule_map)
    "call jspretmpl#loadOtherSyntax(k)
    "call jspretmpl#applySyntax(k, s:rule_map[k])
  "endfor
  "if a:0 == 1
    "let l:ft = a:1
    "call jspretmpl#loadOtherSyntax(l:ft)
    "if !len(keys(s:rule_map))
      "call jspretmpl#applySyntax(l:ft, '')
    "else
      "call jspretmpl#applySyntax(l:ft, '`')
    "endif
  "endif
"endfunction

"function! jspretmpl#clear()
  "if !exists('b:jspre_current_ft')
    "return
  "endif
  "execute 'syntax clear '.s:tmplSyntaxRegion(b:jspre_current_ft)
"endfunction

"let &cpo = s:save_cpo
"unlet s:save_cpo

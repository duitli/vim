"======================================================================
"
" misc.vim - edit details
"
" created by: skywind in 2016/9/19 1:00:44
" last change: 2016/9/19 1:00:44
"
"======================================================================

"-----------------------------------------------------------------------
" insert before current line
"-----------------------------------------------------------------------
function! s:snip(text)
	call append(line('.') - 1, a:text)
endfunc


"-----------------------------------------------------------------------
" guess comment
"-----------------------------------------------------------------------
function! s:comment()
	let l:ext = expand('%:e')
	if &filetype == 'vim'
		return '"'
	elseif index(['c', 'cpp', 'h', 'hpp', 'hh', 'cc', 'cxx'], l:ext) >= 0
		return '//'
	elseif index(['m', 'mm', 'java', 'go', 'delphi', 'pascal'], l:ext) >= 0
		return '//'
	elseif index(['coffee', 'as'], l:ext) >= 0
		return '//'
	elseif index(['c', 'cpp', 'rust', 'go', 'javascript'], &filetype) >= 0
		return '//'
	elseif index(['coffee'], &filetype) >= 0
		return '//'
	elseif index(['sh', 'bash', 'python', 'php', 'perl'], $filetype) >= 0
		return '#'
	elseif index(['make', 'ruby'], $filetype) >= 0
		return '#'
	elseif index(['py', 'sh', 'pl', 'php', 'rb'], l:ext) >= 0
		return '#'
	elseif index(['asm', 's'], l:ext) >= 0
		return ';'
	elseif index(['asm'], &filetype) >= 0
		return ';'
	elseif index(['sql'], l:ext) >= 0
		return '--'
	elseif index(['basic'], &filetype) >= 0
		return "'"
	endif
	return ""
endfunc


"-----------------------------------------------------------------------
" comment bar
"-----------------------------------------------------------------------
function! s:comment_bar(repeat, limit)
	let l:comment = s:comment()
	while strlen(l:comment) < a:limit
		let l:comment .= a:repeat
	endwhile
	return l:comment
endfunc


"-----------------------------------------------------------------------
" comment block
"-----------------------------------------------------------------------
function! <SID>snip_comment_block(repeat)
	let l:comment = s:comment()
	let l:complete = s:comment_bar(a:repeat, 71)
	if l:comment == ''
		return
	endif
	call s:snip(l:complete)
	call s:snip(l:comment . ' ')
	call s:snip(l:complete)
endfunc


"-----------------------------------------------------------------------
" copyright
"-----------------------------------------------------------------------
function! <SID>snip_copyright(author)
	let l:c = s:comment()
	let l:complete = s:comment_bar('=', 71)
	let l:filename = expand("%:t")
	let l:t = strftime("%c")
	let l:text = []
	if &filetype == 'python'
		let l:text += ['#! /usr/bin/env python']
		let l:text += ['# -*- coding: utf-8 -*-']
	elseif &filetype == 'sh'
		let l:text += ['#! /bin/sh']
	elseif &filetype == 'php'
	endif
	let l:text += [l:complete]
	let l:text += [l:c]
	let l:text += [l:c . ' ' . l:filename . ' - ...' ]
	let l:text += [l:c]
	let l:text += [l:c . ' created by: ' . a:author . ' in '. l:t]
	let l:text += [l:c . ' last change: ' . l:t ]
	let l:text += [l:c]
	let l:text += [l:complete]
	let l:text += ['']
	call append(0, l:text)
endfunc


"-----------------------------------------------------------------------
" hot keys
"-----------------------------------------------------------------------
noremap <space>e- :call <SID>snip_comment_block('-')<cr>
noremap <space>e= :call <SID>snip_comment_block('=')<cr>
noremap <space>ec :call <SID>snip_copyright('skywind')<cr>
noremap <space>et "=strftime("%c")<CR>gP



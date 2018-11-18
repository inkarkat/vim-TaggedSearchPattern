" TaggedSearchPattern.vim: Attach names to search patterns for easier recall.
"
" DEPENDENCIES:
"
" Copyright: (C) 2012-2018 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

let s:save_updatetime = &updatetime
function! s:InstallCommandLineHook( isMakeUnique )
    if ! a:isMakeUnique && empty(g:TaggedSearchPattern_UniqueTagPattern)
	return
    endif

    " A straightforward hook would be a cmap on <CR>. But there may be mapping
    " contention around <CR>, and there are issues with opening folds at the
    " search result, and not triggering expansion of :cabbrev any more.
    " Therefore, we define a fire-once autocmd that should trigger soon after
    " leaving command-line mode.
    if &updatetime > 1 | let s:save_updatetime = &updatetime | endif
    set updatetime=1
    augroup TaggedSearchPatternUniqueHook
	execute printf('autocmd! CursorHold,CursorMoved * call TaggedSearchPattern#MakeCurrentTagUnique(%d) | set updatetime=%d | autocmd! TaggedSearchPatternUniqueHook', a:isMakeUnique, s:save_updatetime)
    augroup END
endfunction
function! TaggedSearchPattern#MakeCurrentTagUnique( isMakeUnique )
    let l:neutralTagExprStartPos = stridx(@/, g:TaggedSearchPattern_NeutralTagExpr)
    if l:neutralTagExprStartPos == -1
	return
    endif
    let l:tag = strpart(@/, 0, l:neutralTagExprStartPos)
    if ! a:isMakeUnique && l:tag !~# g:TaggedSearchPattern_UniqueTagPattern
	return
    endif

    let l:lastSearchHistory = histget('search', -1)
    let l:tagLiteralExpr = '\C\V\^' . escape(l:tag, '\') . escape(g:TaggedSearchPattern_NeutralTagExpr, '\')
    call histdel('search', l:tagLiteralExpr)
    call histadd('search', l:lastSearchHistory)
endfunction
function! TaggedSearchPattern#ToggleTag( isMakeUnique )
    let l:cmdline = getcmdline()

    let l:neutralTagExprStartPos = stridx(l:cmdline, g:TaggedSearchPattern_NeutralTagExpr)
    if l:neutralTagExprStartPos == -1
	call setcmdpos(1)
	call s:InstallCommandLineHook(a:isMakeUnique)
	return g:TaggedSearchPattern_NeutralTagExpr . l:cmdline
    else
	let l:tagLen = l:neutralTagExprStartPos + len(g:TaggedSearchPattern_NeutralTagExpr)
	let l:cmdline = strpart(l:cmdline, l:tagLen)

	call setcmdpos(max([1, getcmdpos() - l:tagLen]))
	return l:cmdline
    endif
endfunction

function! TaggedSearchPattern#HistAdd( tag, pattern, ... )
    let l:isMakeUnique = (a:0 ? a:1 : 0)
    call histadd('search', a:tag . g:TaggedSearchPattern_NeutralTagExpr . a:pattern)
    call TaggedSearchPattern#MakeCurrentTagUnique(l:isMakeUnique)
endfunction

function! TaggedSearchPattern#Filter()
    let l:neutralTagLiteralExpr = '\C\V' . escape(g:TaggedSearchPattern_NeutralTagExpr, '/\')

    execute printf('silent! %vglobal/%s/delete _', l:neutralTagLiteralExpr)

    " Deletion messes up the natural window layout, with the last line at the
    " bottom of the window, and no padding. Fix that.
    normal! zb

    call histdel('search', -1)
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :

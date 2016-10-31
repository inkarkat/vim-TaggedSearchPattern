" TaggedSearchPattern.vim: Attach names to search patterns for easier recall.
"
" DEPENDENCIES:
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.002	09-Jul-2012	Do the highlighting for all opened search
"				command-line windows, not just the ones opened
"				via q<C-T>.
"				Add TaggedSearchPattern#HistAdd() utility
"				function.
"	001	06-Jul-2012	file creation

function! TaggedSearchPattern#ToggleTag()
    let l:cmdline = getcmdline()

    let l:neutralTagExprStartPos = stridx(l:cmdline, g:TaggedSearchPattern_NeutralTagExpr)
    if l:neutralTagExprStartPos == -1
	call setcmdpos(1)
	return g:TaggedSearchPattern_NeutralTagExpr . l:cmdline
    else
	let l:tagLen = l:neutralTagExprStartPos + len(g:TaggedSearchPattern_NeutralTagExpr)
	let l:cmdline = strpart(l:cmdline, l:tagLen)

	call setcmdpos(max([1, getcmdpos() - l:tagLen]))
	return l:cmdline
    endif
endfunction

function! TaggedSearchPattern#HistAdd( tag, pattern )
    call histadd('search', a:tag . g:TaggedSearchPattern_NeutralTagExpr . a:pattern)
endfunction

function! TaggedSearchPattern#Filter()
    let l:neutralTagLiteral = '\C\V' . escape(g:TaggedSearchPattern_NeutralTagExpr, '/\')

    execute printf('silent! %vglobal/%s/d _', l:neutralTagLiteral)

    " Deletion messes up the natural window layout, with the last line at the
    " bottom of the window, and no padding. Fix that.
    normal! zb
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :

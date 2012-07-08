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
"	001	06-Jul-2012	file creation

let s:neutralTagExpr = '\%$%\|'

function! TaggedSearchPattern#ToggleTag()
    let l:cmdline = getcmdline()

    let l:neutralTagExprStartPos = stridx(l:cmdline, s:neutralTagExpr)
    if l:neutralTagExprStartPos == -1
	call setcmdpos(1)
	return s:neutralTagExpr . l:cmdline
    else
	let l:tagLen = l:neutralTagExprStartPos + len(s:neutralTagExpr)
	let l:cmdline = strpart(l:cmdline, l:tagLen)

	call setcmdpos(max([1, getcmdpos() - l:tagLen]))
	return l:cmdline
    endif
endfunction

function! TaggedSearchPattern#Filter()
    let l:neutralTagLiteral = '\C\V' . escape(s:neutralTagExpr, '/\')

    execute printf('silent! %vglobal/%s/d _', l:neutralTagLiteral)

    " Deletion messes up the natural window layout, with the last line at the
    " bottom of the window, and no padding. Fix that.
    normal! zb

    if g:TaggedSearchPattern_HighlightTags && exists('*matchadd')
	call matchadd('TaggedSearchTag', '^.\{-}\ze' . l:neutralTagLiteral, 10)
	call matchadd('TaggedSearchNeutral', l:neutralTagLiteral, 10)
	" No need to note the returned match ID; the eventual close of the
	" command-line window will automatically clean this up.
    endif
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :

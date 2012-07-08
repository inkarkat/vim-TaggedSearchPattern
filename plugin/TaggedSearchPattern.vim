" TaggedSearchPattern.vim: Attach names to search patterns for easier recall.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.
"   - TaggedSearchPattern.vim autoload script
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	06-Jul-2012	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_TaggedSearchPattern') || (v:version < 700)
    finish
endif
let g:loaded_TaggedSearchPattern = 1

"- configuration ---------------------------------------------------------------

if ! exists('g:TaggedSearchPattern_HighlightTags')
    let g:TaggedSearchPattern_HighlightTags = 1
endif


"- mappings --------------------------------------------------------------------

cnoremap <expr> <C-t> (stridx('/?', getcmdtype()) == -1 ? '<C-t>' : '<C-\>e(TaggedSearchPattern#ToggleTag())<CR>')

nnoremap <silent> <Plug>(TaggedSearchPatternList) q/:call TaggedSearchPattern#Filter()<CR>
if ! hasmapto('<Plug>(TaggedSearchPatternList)', 'n')
    nmap q<C-t> <Plug>(TaggedSearchPatternList)
endif


"- highlight groups ------------------------------------------------------------

highlight def link TaggedSearchTag Directory
highlight def link TaggedSearchNeutral NonText

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :

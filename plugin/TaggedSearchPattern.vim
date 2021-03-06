" TaggedSearchPattern.vim: Attach names to search patterns for easier recall.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.
"   - TaggedSearchPattern.vim autoload script
"
" Copyright: (C) 2012-2018 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_TaggedSearchPattern') || (v:version < 700)
    finish
endif
let g:loaded_TaggedSearchPattern = 1

"- configuration ---------------------------------------------------------------

if ! exists('g:TaggedSearchPattern_NeutralTagExpr')
    " Note: This must be a regexp that never matches anywhere.
    let g:TaggedSearchPattern_NeutralTagExpr = '\%$%\|'
endif

if ! exists('g:TaggedSearchPattern_UniqueTagPattern')
    let g:TaggedSearchPattern_UniqueTagPattern = '.!$'
endif

if ! exists('g:TaggedSearchPattern_HighlightTags')
    let g:TaggedSearchPattern_HighlightTags = 1
endif


"- autocmds --------------------------------------------------------------------

if g:TaggedSearchPattern_HighlightTags && exists('*matchadd')
    function! s:HighlightTags()
	let l:neutralTagLiteral = '\C\V' . escape(g:TaggedSearchPattern_NeutralTagExpr, '/\')

	call matchadd('TaggedSearchTag', '^.\{-}\ze' . l:neutralTagLiteral, 10)
	call matchadd('TaggedSearchNeutral', l:neutralTagLiteral, 10)
	" No need to note the returned match ID; the eventual close of the
	" command-line window will automatically clean this up.
    endfunction

    augroup TaggedSearchPattern
	autocmd! CmdwinEnter /,? call <SID>HighlightTags()
    augroup END
endif


"- mappings --------------------------------------------------------------------

cnoremap <expr> <Plug>(TaggedSearchPatternToggle) (stridx('/?', getcmdtype()) == -1 ? '<C-t>' : '<C-\>e(TaggedSearchPattern#ToggleTag(0))<CR>')
if ! hasmapto('<Plug>(TaggedSearchPatternToggle)', 'c')
    cmap <C-t> <Plug>(TaggedSearchPatternToggle)
endif
cnoremap <expr> <Plug>(TaggedSearchPatternUniqueToggle) (stridx('/?', getcmdtype()) == -1 ? '<C-t>' : '<C-\>e(TaggedSearchPattern#ToggleTag(1))<CR>')
if ! hasmapto('<Plug>(TaggedSearchPatternUniqueToggle)', 'c')
    cmap <C-g><C-t> <Plug>(TaggedSearchPatternUniqueToggle)
endif

nnoremap <silent> <Plug>(TaggedSearchPatternList) q/:call TaggedSearchPattern#Filter()<CR>
if ! hasmapto('<Plug>(TaggedSearchPatternList)', 'n')
    nmap q<C-t> <Plug>(TaggedSearchPatternList)
endif


"- highlight groups ------------------------------------------------------------

highlight def link TaggedSearchTag Title
highlight def link TaggedSearchNeutral NonText

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :

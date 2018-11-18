TAGGED SEARCH PATTERN   
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

You use text searches all the time in Vim. While it is simple to recall
previous patterns through the cmdline-history, quickly recognizing them can
be hard, especially if it's a long convoluted regular expression that you've
confidently built some hours ago, but now all variants stored in the history
look like nearly identical gibberish.

This plugin allows you to "tag" individual searches with a name, so that these
searches are documented and therefore become easier to recognize and recall.
You can also pre-seed your search history with frequently needed searches.

### HOW IT WORKS

Tagged searches reside in the normal search history like all other searches.
The tagging works by prepending a special regular expression branch that never
matches any text.

### RELATED WORKS

Inspired by
http://stackoverflow.com/questions/10174171/indicator-to-see-from-which-function-a-search-string-comes/

An alternative is to append a literal NUL character (^@, enter via <C-V><C-@>)
after the concluded search pattern, e.g.

    /foobar/^@tag here

Vim will ignore everything after the NUL byte, but it'll still show the whole
line in the search history, including the tag. (Discovered by glts in
http://stackoverflow.com/a/20020360/813602) This depends on an implementation
detail, and the tag position makes it more difficult to search / recall.

USAGE
------------------------------------------------------------------------------

    Inside the search command-lines (:/, :?), tag (and un-tag) the current
    search with CTRL-T, type the tag name, and store and activate the search with
    <Enter> as usual.
    Since tagged searches start with the tag, recall is as simple as entering the
    search command-line via :/, typing the first letters of the tag and pressing
    c_<Up> (repeatedly if there are many).
    When you're in the cmdline-window via q/, just search for tags via
    /^{tag-name}. Or open a filtered view of the search cmdline-window through
    q_CTRL-T.

    CTRL-T                  Prepend the search-neutral tag expression and position
                            the cursor before it at the beginning of the
                            command-line, so that the tag can be entered.
                            For the tag, stick to alphanumeric characters
                            (whitespace is okay, too). Do not use characters like
                            \, &, |, etc. that have a special meaning in a regexp!

                            When the current search already has been tagged:
                            Remove the tag and the following search-neutral tag
                            expression.
                            You can use CTRL-T CTRL-T to rename a tagged search
                            pattern.

    CTRL-G CTRL-T           Like c_CTRL-T, but ensure that the search tag will
                            be unique in the search history (by removing any
                            previous searches with the same tag)
                            g:TaggedSearchPattern_UniqueTagPattern

    q CTRL-T                Open the search command-line window as with q/ and
                            list only tagged searches. The tag names are
                            highlighted for easier recognition. As usual, <Enter>
                            uses the current search pattern under the cursor, or
                            press CTRL-C to continue editing in Command-line mode.

    If you don't use them, tagged searches will eventually be expelled from the
    search history, just like any other search pattern. You can delay this by
    increasing the 'history' setting and the "/" value of 'viminfo'.
    Alternatively, you can automatically define often-used tagged searches
    (globally in .vimrc, or maybe only when certain filetypes are loaded via a
    ftplugin), like this:
        call TaggedSearchPattern#HistAdd('mytag', '\<search\d\+\|pattern\>')
        call TaggedSearchPattern#HistAdd('unique', '\<pattern\>', 1)

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-TaggedSearchPattern
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim TaggedSearchPattern*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

For certain tag names, you can ensure that each tagged search pattern only
exists once in the search history (previous patterns with the same tag are
deleted). By default, any tag name ending with a "!" is a unique one:

    let g:TaggedSearchPattern_UniqueTagPattern = '.!$'

To make all tag searches unique, use this:

    let g:TaggedSearchPattern_UniqueTagPattern = '.'

To turn off the highlighting of the tag name and search-neutral tag expression
in the search cmdline-window:

    let g:TaggedSearchPattern_HighlightTags = 0

To change the highlighting colors, redefine (after any :colorscheme command)
or link the two highlight groups:

    highlight link TaggedSearchTag Search
    highlight TaggedSearchNeutral ctermfg=Black guifg=White

If you want to use different mappings, map your keys to the
<Plug>(TaggedSearchPattern...) mapping targets _before_ sourcing the script
(e.g. in your vimrc):

    cmap <C-t> <Plug>(TaggedSearchPatternToggle)
    cmap <C-g><C-t> <Plug>(TaggedSearchPatternUniqueToggle)
    nmap q<C-t> <Plug>(TaggedSearchPatternList)

CONTRIBUTING
------------------------------------------------------------------------------

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-TaggedSearchPattern/issues or email (address
below).

HISTORY
------------------------------------------------------------------------------

##### 1.10    18-Nov-2018
- Make <C-t> mapping configurable.
- ENH: Allow unique tags, identified via
  g:TaggedSearchPattern\_UniqueTagPattern or forced via different mapping.
- Add <C-g><C-t> variant that enforces unique tag.
- Minor: Remove q<C-t> filter pattern from search history.

##### 1.00    09-Jul-2012
- First published version.

##### 0.01    06-Jul-2012
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2012-2018 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat <ingo@karkat.de>

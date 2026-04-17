if exists("b:current_syntax")
  finish
endif

runtime! syntax/html.vim

sy match noteQuote "^>.*$"
sy match noteCodeBlock "^\(\s\{4\}\|\t\).*"

sy match noteHeading1 "^#.*#$"
sy match noteHeading2 "^##.*##$"
sy match noteHeading3 "^###.*###$"

sy region noteCode start="`" end="`" oneline
sy region noteLink start="\[" end="\](.*)" oneline contains=noteLinkText,noteLinkUrl
sy match noteLinkText "\[.\{-}\]" contained contains=@NoSpell
sy match noteLinkUrl "(.\{-})" contained

sy region noteUnderline start="\(^\|\s\)\@<=_" end="_\(\s\|$\)\@=" oneline contains=@NoSpell
sy region noteBold start="\(^\|\s\)\@<=\*" end="\*\(\s\|$\)\@=" oneline contains=@NoSpell
sy region noteItalics start="\(^\|\s\)\@<=\/" end="\/\(\s\|$\)\@=" oneline contains=@NoSpell

hi def link noteQuote Comment
hi def link noteCode Comment
hi def link noteCodeBlock Comment
hi def noteLink gui=underline cterm=underline
hi def link noteLinkUrl Comment

hi def link noteHeading1 Constant
hi def link noteHeading2 Type
hi def link noteHeading3 Keyword

hi def noteUnderline gui=underline cterm=underline
hi def noteBold gui=bold cterm=bold
hi def noteItalics gui=italic cterm=italic

let b:current_syntax = "note"

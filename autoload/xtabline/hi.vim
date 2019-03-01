""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Highlight
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:Hi   = g:xtabline_highlight
let s:Sets = g:xtabline_settings

fun! xtabline#hi#init()
  let s:Sets.theme = get(s:Sets, 'theme', 'default')
  call xtabline#hi#apply_theme(s:Sets.theme)
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! xtabline#hi#apply_theme(theme)
  """Apply a theme."""

  call s:clear_groups()

  if a:theme == 'default'
    let s:last_theme = a:theme
    return s:Hi.themes.default()
  endif

  if !xtabline#themes#init(a:theme)
    echohl WarningMsg | echo "Wrong theme." | echohl None | return
  endif

  let theme = s:Hi.themes[a:theme]

  for group in keys(theme)
    if theme[group][1]
      exe "hi link ".group." ".theme[group][0]
    else
      exe "hi ".group." ".theme[group][0]
    endif
  endfor

  let s:Sets.theme = a:theme
  let s:last_theme = a:theme
endfun

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! xtabline#hi#load_theme(bang, theme)
  """Load a theme."""
  if a:bang
    call xtabline#hi#apply_theme(s:last_theme)
    echo "[xtabline] " | echohl Special | echon "Theme reloaded: " s:last_theme | echohl None
  elseif !empty(a:theme)
    call xtabline#hi#apply_theme(a:theme)
    echo "[xtabline] " | echohl Special | echon "Theme switched to " a:theme | echohl None
  else
    echo "[xtabline] " | echohl WarningMsg | echon "No theme specified." | echohl None
  endif
endfun

fun! s:clear_groups()
  """Clear highlight before applying a theme."""
  silent! hi clear XTSelect
  silent! hi clear XTSelectMod
  silent! hi clear XTVisible
  silent! hi clear XTVisibleMod
  silent! hi clear XTHidden
  silent! hi clear XTHiddenMod
  silent! hi clear XTExtra
  silent! hi clear XTExtramod
  silent! hi clear XTSpecial
  silent! hi clear XTTabActive
  silent! hi clear XTTabInactive
  silent! hi clear XTNumSel
  silent! hi clear XTNum
  silent! hi clear XTFill
endfun

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:style(k)
  let s = !a:k ? "NONE" : a:k==1 ? "BOLD" : a:k==2 ? "ITALIC" : "UNDERLINE"
  return ("term=".s." cterm=".s." gui=".s)
endfun

fun! xtabline#hi#generate(name, theme)
  """Create an entry in g:xtabline_highlight.themes for the give theme."""
  let t = a:theme | let T = {}

  for h in keys(t)
    let T[h] = [printf(
          \"ctermfg=%s ctermbg=%s guifg=%s guibg=%s ".s:style(t[h][4]),
          \t[h][0], t[h][1], t[h][2], t[h][3]), 0]
  endfor
  let s:Hi.themes[a:name] = T
endfun

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! xtabline#hi#update_theme()
  """Reload theme on colorscheme switch."""
  if g:xtabline_settings.theme == s:last_theme
    call xtabline#hi#apply_theme(g:xtabline_settings.theme)
  endif
endfun

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Default theme
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:Hi.themes.default()
  hi! link XTSelect     TabLineSel
  hi! link XTVisible    Special
  hi! link XTHidden     TabLine
  hi! link XTSelectMod  TabLineSel
  hi! link XTVisibleMod Special
  hi! link XTHiddenMod  WarningMsg
  hi! link XTExtra      PmenuSel
  hi! link XTSpecial    DiffAdd
  hi! link XTFill       TabLineFill
  hi! link XTVisibleTab TabLineSel
  hi! link XTNumSel     DiffAdd
  hi! link XTNum        Special
endfun


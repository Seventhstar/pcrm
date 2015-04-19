# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


@fixEncode = (loc) ->
  h = loc.split('#')
  l = h[0].split('?')
  l[0] + (if l[1] then '?' + ajx2q(q2ajx(l[1])) else '') + (if h[1] then '#' + h[1] else '')


@setLoc = (loc) ->
  navPrefix = ''
  curLoc = fixEncode(loc)
  
  l = (location.toString().match(/#(.*)/) or {})[1] or ''
  if !l
    l = (location.pathname or '') + (location.search or '')
  l = fixEncode(l)
  #alert(navPrefix + curLoc)
  #l = l.replace(/#/, '')
  if l.replace(/^(\/|!)/, '') != curLoc
    try
      history.pushState {}, '', '/' + curLoc
      return
    catch e

    window.chHashFlag = true
    location.hash = navPrefix + curLoc

    if withFrame and getLoc() != curLoc
      setFrameContent curLoc
  return
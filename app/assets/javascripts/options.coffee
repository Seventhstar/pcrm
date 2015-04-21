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

@ajx2q = (qa) ->
  query = []

  enc = (str) ->
    if window._decodeEr and _decodeEr[str]
      return str
    try
      return encodeURIComponent(str)
    catch e
      return str
    return

  for key of qa
    if qa[key] == null or isFunction(qa[key])
      continue
    if isArray(qa[key])
      i = 0
      c = 0
      l = qa[key].length
      while i < l
        if qa[key][i] == null or isFunction(qa[key][i])
                    ++i
          continue
        query.push enc(key) + '[' + c + ']=' + enc(qa[key][i])
        ++c
        ++i
    else
      query.push enc(key) + '=' + enc(qa[key])
  query.sort()
  query.join '&'

@q2ajx = (qa) ->
  if !qa
    return {}
  query = {}

  dec = (str) ->
    try
      return decodeURIComponent(str)
    catch e
      window._decodeEr = window._decodeEr or {}
      _decodeEr[str] = 1
      return str
    return

  qa = qa.split('&')
  each qa, (i, a) ->
    t = a.split('=')
    if t[0]
      v = dec(t[1] + '')
      if t[0].substr(t.length - 2) == '[]'
        k = dec(t[0].substr(0, t.length - 2))
        if !query[k]
          query[k] = []
        query[k].push v
      else
        query[dec(t[0])] = v
    return
  query  


@each = (object, callback) ->
  if !isObject(object) and typeof object.length != 'undefined'
    i = 0
    length = object.length
    while i < length
      value = object[i]
      if callback.call(value, i, value) == false
        break
      i++
  else
    for name of object
      if !Object::hasOwnProperty.call(object, name)
        i++
        continue
      if callback.call(object[name], name, object[name]) == false
        break
  object

isObject = (obj) ->
  Object::toString.call(obj) == '[object Object]' and !(browser.msie8 and obj and obj.item != 'undefined' and obj.namedItem != 'undefined')
isFunction = (obj) ->
  Object::toString.call(obj) == '[object Function]'  
isArray = (obj) ->
  Object::toString.call(obj) == '[object Array]'
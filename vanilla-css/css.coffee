css = do ->

  d = document.createElement "div"

  # appropriated from jQuery.cssNumber
  unitless = [ "column-count", "fill-opacity", "font-weight", "line-height", "opacity", "orphans", "widows", "z-index", "zoom" ]

  # http://stackoverflow.com/questions/8955533/javascript-jquery-split-camelcase-string-and-add-hyphen-rather-than-space
  dasherize = ( str ) ->
    str.replace( /([a-z])([A-Z])/g, "$1-$2" ).toLowerCase()

  getPrefixedStyle = ( style ) ->
    webkit = "-webkit-" + style
    moz = "-moz-" + style
    ms = "-ms-" + style
    o = "-o-" + style 
    if d.style[style]?
      return style
    else if d.style[webkit]?
      return webkit
    else if d.style[moz]?
      return moz
    else if d.style[ms]?
      return ms
    else if d.style[o]?
      return o
    else
      return style

  ( el, obj ) ->
    if typeof obj is "string"
      prop = getPrefixedStyle dasherize obj
      el = el[0] or el
      return el.style[prop] or getComputedStyle( el )[ prop ]
    if el.length?
      [].forEach.call el, ( n ) ->
        css n, obj
    else
      for key, val of obj
        key = dasherize( key )
        if typeof val is "number" and key not in unitless
          val += "px"
        el.style[getPrefixedStyle( key )] = val
      return

# recursive function that can take a while to run. Probably don't set "s" to more than 8 or 9.

timeWaster = ( s, l, base = [] ) ->

    makeId  = ( l ) ->
      text = ""
      possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
      i = 0
      while i < l
        text += possible.charAt(Math.floor(Math.random() * possible.length))
        i++
      text

    if s is 0
      for j in [0..l]
        base[j] = makeId( l )
    else   
      for i in [0..s]
        base[i] = []
        timeWaster( s - 1, l, base[i] )
    return base

root = ( if typeof exports isnt "undefined" and exports isnt null then exports else this )
root.timeWaster = timeWaster
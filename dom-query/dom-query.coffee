query = do ->

  unless String::contains
    String::contains = ->
      String::indexOf.apply @, arguments

  slice = Function.prototype.call.bind( Array.prototype.slice )

  ( param ) ->

    elements = undefined
    
    if param.split( " " ).length isnt 1 or param.contains "["
      
      elements = slice document.querySelectorAll param

    else

      if param.charAt( 0 ) is "#"
        elements = [ document.getElementById param.slice 1 ]

      else if param.charAt( 0 ) is "."
        elements = slice document.getElementsByClassName param.slice 1
      
      else
        elements = slice document.getElementsByTagName param
    
    elements

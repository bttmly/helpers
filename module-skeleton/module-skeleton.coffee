# Modular skeleton
# Remember to *require* and *define* all dependencies
# AND add dependencies to all calls to factory()
# AND rename 'Module' to the real name

( ( root, factory ) ->
  if typeof define is "function" and define.amd
    define [
      # dependency
      # dependency
      "exports"
    ], ( exports ) ->
      root.Module = factory( root, exports )
      return  

  else if typeof exports isnt "undefined"
    # _ = require( dependency )
    factory( root, exports )

  else
    root.Module = factory( root, {} )

  return

)( this, ( root, Module, _ ) ->
  
  previousModule = root.Module

  class Module

  Module.noConflict = ->
    root.Module = previousModule
    return this

  return Module
  
)
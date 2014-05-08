class A

  aMethod : -> 
    console.log "aMethod from class A"
    console.log "this instance of A === " + ( @ instanceof A )

class B

  bMethod : -> 
    console.log "bMethod from class B"
    console.log "this instance of B === " + ( @ instanceof B )

class C
  constructor : ->
    @a = new A()
    @b = new B()

  compose
    composeTo: @
    composeFrom:
      a: A
      b: B
    bindMethods true

class D
  constructor : ->
    @a = new A()
    @b = new B()

  compose
    composeTo: @
    composeFrom:
      a: A
      b: B

# addEventListener will throw an exception
# due to bindMethods === true
class F
  constructor : ->
    @e = document.createElement( "div" )

  compose 
    composeTo: @
    composeFrom: 
      e: Element
    bindMethods: true


# addEventListener will work fine here
class G
  constructor : ->
    @e = document.createElement( "div" )
 
  compose 
    composeTo: @
    composeFrom: 
      e: Element

# Mess with bindMethods and bindCallbacks
# and use .runFn( -> @ ) to check the context
class Y
  runFn : ( fn ) -> fn()

class Z
  constructor: ->
    @y = new Y()

  compose
    composeTo: @
    composeFrom:
      y : Y
    bindMethods: true
    bindCallbacks: true

this.A = A
this.B = B
this.C = C
this.D = D

this.F = F
this.G = G

this.Y = Y
this.Z = Z
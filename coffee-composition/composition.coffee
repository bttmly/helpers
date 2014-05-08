# helper functions for accessing prototypes and their methods
isFunction = ( obj ) ->
  obj and Object.prototype.toString.call( obj ) is "[object Function]"

getPrototypeChain = ( obj ) ->
  chain = []
  chain.push( obj )
  while obj = Object.getPrototypeOf( obj )
    chain.push obj unless obj is Object.prototype
  chain

getPrototypeMethods = ( proto ) ->
  # check if we're given the CLASS rather than the prototype.
  proto = proto.prototype if isFunction proto
  Object.getOwnPropertyNames( proto ).filter ( propName ) ->
    propName isnt "constructor" and isFunction proto[ propName ]

getPrototypeChainMethods = ( obj ) ->
  # check if we're given the CLASS rather than the prototype.
  obj = obj.prototype if isFunction obj
  chain = getPrototypeChain( obj )
  methods = []
  for proto in chain
    [].push.apply methods, getPrototypeMethods( proto )
  methods



class Composable
  @compose = ( componentObj, deep ) ->
    for prop, className of componentObj
      do ( prop, className ) =>
        chain = ( if deep then getPrototypeChain( className.prototype ) else [ className.prototype ] )
        for proto in chain
          do ( proto ) =>
            for method in getPrototypeMethods( proto )
              do ( method ) =>
                @::[method] = ->
                  proto[method].apply( @[prop], arguments )



window.A = class A

  aMethod : -> 
    console.log "aMethod from class A"
    console.log "this instance of A === " + ( @ instanceof A )



window.B = class B

  bMethod : -> 
    console.log "bMethod from class B"
    console.log "this instance of B === " + ( @ instanceof B )



window.C = class C extends Composable
  constructor : ->
    @a = new A()
    @b = new B()

  @compose { a : A, b : B }



# note that for some "classes" (those that are actually "interfaces", whatever that means)
# you can't instantiate them via "new", so you need to create an instance some other way.
# this class doesn't EXTEND Composable; we're just calling Composable.compose from w/in
# the class definition. Compose could exist as a standalone function, and could be modified
# to take the class you're composing as an argument, or called after being bound (as here).
window.D = class D
  constructor : ->
    @a = new A()
    @b = new B()
    @e = document.createElement( "div" )

  onThis : ( method, rest... ) ->
    args = [].slice.call rest
    args = args.map ( arg ) ->
      if isFunction( arg ) then arg.bind( @ ) else arg
    console.log args
    @[method].apply( @, args )

  Composable.compose.bind( @ )( { a : A, b : B, e : Element }, true );

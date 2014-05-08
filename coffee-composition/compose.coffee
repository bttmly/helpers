this.compose = compose = do ->

  each = ( obj, itr ) ->
    list = if Array.isArray( obj ) then obj.map ( e, i ) ->  i else Object.keys( obj )
    i = 0
    while i < list.length
      itr( obj[ list[i] ], list[ i ], obj )
      i += 1
    obj

  isFunction = ( obj ) ->
    obj and Object.prototype.toString.call( obj ) is "[object Function]"

  getPrototypeChain = ( obj ) ->
    chain = []
    obj = obj.constructor if obj.constructor isnt Function
    obj = obj.prototype if isFunction( obj )
    chain.push( obj )
    chain.push( obj ) while obj = Object.getPrototypeOf( obj )
    chain

  getPrototypeMethods = ( proto ) ->
    proto = proto.constructor if proto.constructor isnt Function
    proto = proto.prototype if isFunction( proto )
    Object.getOwnPropertyNames( proto ).filter ( propName ) ->
      isFunction proto[ propName ]

  ( opt ) ->
    { composeTo, composeFrom, bindMethods, bindCallbacks } = opt
    each composeFrom, ( cl, prop ) =>
      each getPrototypeChain( cl.prototype ), ( proto ) =>
        each getPrototypeMethods( proto ), ( method ) =>
          unless composeTo::[method]
            composeTo::[method] = ->
              context = if bindMethods then @ else @[prop]
              args = [].slice.call arguments
              if bindCallbacks
                args = args.map ( arg ) ->
                  if isFunction( arg ) then arg.bind( context ) else arg
              proto[method].apply( context, args )



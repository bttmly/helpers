class FunctionWorker

  constructor : ( fn, name ) ->
    @fn = fn
    @name = name
    @blob = new Blob [ FunctionWorker.workerStrFromFn( fn, name ) ]
    @blobURL = URL.createObjectURL( @blob ) 
    @worker = new Worker( @blobURL )

  start : ( args, thisArg ) ->
    @worker.postMessage
      cmd : "start"
      args : if args.length? then args else [args]
      thisArg : thisArg or null

  stop : ->
    @worker.postMessage
      cmd: "stop"
    @terminated = true

  @workerStrFromFn = ( fn, fnName ) ->
    """
    self.addEventListener( "message", function( event ) {
      var cmd = event.data.cmd;
      var args = event.data.args;
      var thisArg = event.data.thisArg;
      var result;
      var timer;
      if ( cmd === "start" ) {
        // var timer = new Date();
        var #{ fnName } = #{ fn.toString() }
        var result = #{ fnName }.apply( thisArg, args );
        // var timer = new Date() - timer
        self.postMessage({ type: "result", msg: "Worker complete.", value: result });

      } else if ( cmd === "stop" ) {
        self.postMessage({ type: "stop", msg: "Stopped on command." });

      } else {
        self.postMessage({ type: "stop", msg: "Invalid command."})

      }
    });
    """

root = ( if typeof exports isnt "undefined" and exports isnt null then exports else this )
root.FunctionWorker = FunctionWorker
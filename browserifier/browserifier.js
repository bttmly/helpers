var fs = require("fs");
var npm = require("npm");
var exec = require("child_process").exec;
var b = require("browserify")();
var args = process.argv.slice(2);
var moduleName = args[0];
var varName = args[1] || args[0];

var camelize = function(str) {
  return str.replace(/(?:^|[-_])(\w)/g, function(_, c) {
    if (c) {
      return c.toUpperCase();
    } else {
      return "";
    }
  });
};

var Browserifier = (function() {
  
  function Browserifier(moduleName, varName) {
    this.name = moduleName;
    this.varName = camelize(moduleName);
    console.log("installing....");
    exec("npm install " + this.name, (function(_this) {
      return function(error, stdout, stderr) {
        return _this.writeTemp().bundle();
      };
    })(this));
  }

  Browserifier.prototype.writeTemp = function() {
    var str;
    console.log("writing...");
    this.tmpFile = "./tmp/" + this.name + ".js";
    str = "window." + this.varName + " = require( '" + this.name + "' );";
    fs.writeFileSync(this.tmpFile, str);
    b.add(this.tmpFile);
    return this;
  };

  Browserifier.prototype.bundle = function() {
    console.log("bundling...");
    this.browserFile = "./browser_modules/" + this.name + ".js";
    return b.bundle((function(_this) {
      return function(err, src) {
        return fs.writeFile(_this.browserFile, src, function(err) {
          if (err) {
            throw err;
          }
          return console.log("Module " + _this.name + " has been Browserified.");
        });
      };
    })(this));
  };
  
  return Browserifier;

})();

new Browserifier(moduleName, varName);

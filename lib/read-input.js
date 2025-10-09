/**
 * read-input replacement using native Node.js
 * Reads from files or stdin, compatible with the original read-input API
 */

var fs = require('fs');

function read(files, callback) {
  // Handle callback-only call
  if (typeof files === 'function') {
    callback = files;
    files = [];
  }

  files = files || [];

  // Promise wrapper
  var promise = new Promise(function(resolve, reject) {
    // Read from stdin if no files
    if (files.length === 0) {
      readStdin(function(err, data) {
        if (err) {
          var result = new Result([{ stdin: true, error: err }]);
          resolve(result);
        } else {
          var result = new Result([{ stdin: true, data: data }]);
          resolve(result);
        }
      });
    }
    // Read from files
    else {
      var filesData = files.map(function(fname) {
        try {
          var data = fs.readFileSync(fname, 'utf-8');
          return { name: fname, data: data };
        } catch (err) {
          return { name: fname, error: err };
        }
      });

      resolve(new Result(filesData));
    }
  });

  // Support callback API
  if (callback) {
    promise.then(function(res) { callback(null, res); })
           .catch(function(err) { callback(err); });
  }

  return promise;
}

function readStdin(callback) {
  var chunks = [];

  process.stdin.setEncoding('utf-8');

  process.stdin.on('data', function(chunk) {
    chunks.push(chunk);
  });

  process.stdin.on('end', function() {
    callback(null, chunks.join(''));
  });

  process.stdin.on('error', function(err) {
    callback(err);
  });

  // Handle case where stdin is already closed
  if (process.stdin.isTTY) {
    callback(new Error('No input provided'));
  }
}

function Result(files) {
  this.files = files;
  this.successes = files.filter(function(f) { return !f.error; });
  this.failures = files.filter(function(f) { return f.error; });

  // For single file/stdin, provide direct access
  if (files.length === 1) {
    this.data = files[0].data;
    this.error = files[0].error;
    this.stdin = files[0].stdin || false;
  }
}

read.stdin = readStdin;

module.exports = read;

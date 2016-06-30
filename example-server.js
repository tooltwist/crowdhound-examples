/*
 *	A super small web server to serve up content from the current directory.
 */
var connect = require('connect');
var serveStatic = require('serve-static');

// Binding to 0.0.0.0 causes OSX to bind to the external
// IP address of the machine rather than to localhost.
connect().use(serveStatic(__dirname)).listen(8080, '0.0.0.0', function(){
    console.log('Server running on 8080...');
});

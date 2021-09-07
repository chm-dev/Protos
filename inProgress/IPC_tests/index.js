var net = require('net');

var pipe_named;
pipe_named = net.createServer(function (socket) { }).listen('\\\\.\\pipe\\testpipe'); //=
pipe_named.on('connection', function (socket) {
  console.log("Received a connection on named pipe!");
  socket.on('data', data => { console.log(data.toString()) })
  socket.on('error', function (e) {
    console.error(e);
  });
});

pipe_named.on('error', function (e) {
  console.error(e);
});

var pipe_port = net.createServer(function (socket) { }).listen(51978);
pipe_port.on('connection', function (socket) {
  console.log("Received a connection on port 51978!");
  socket.on('error', function (e) {
    console.error(e);
  });
});
pipe_port.on('error', function (e) {
  console.error(e);
});
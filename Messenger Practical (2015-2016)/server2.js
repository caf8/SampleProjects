var net = require('net');
var http = require('http');
var ws = require('ws');
var url = require('url');
var path = require('path');
var fs = require('fs');
var HOST = 'localhost';
var os = require('os');
var PORT = process.getuid();
var LISTEN_PORT =28250;
var webSocket;    

var line;
var i;
var object;
var nameAndPortArray = [];
var receiverPortNumber;
    
readInData();
    
function readInData(){

var nameAndPortArrayTemp = fs.readFileSync('web_users').toString().split("\n");


for (i = 0; i < nameAndPortArrayTemp.length; i++){
  line =   nameAndPortArrayTemp[i].split(",")
  object = {"receiver": line[0], "port":line[5]}
  nameAndPortArray.push(object);
}
}

function getRecieversPort(receiver){

var receiverName =  receiver;
 nameAndPortArray.forEach(function(element) {
    if(element.receiver == receiverName){
      receiverPortNumber = element.port;
    }
  }, this);
  
  return receiverPortNumber;
}
    
 
    
var server = http.createServer(function (req, resp) {
    const ERROR_MSG =
          {404: "404 File not found.",
           500: "500 Internal server error."};
    const EXT_CONTENT_TYPE =
          {".js"  : "text/javascript",
           ".html": "text/html",
           ".css" : "text/css"};

    var res = url.parse(req.url).pathname;
    var ext = path.extname(res);

    if (!(ext in EXT_CONTENT_TYPE)) {
        resp.writeHead(404, {
            "Content-Type"  : "text/plain",
            "Content-Length": ERROR_MSG[404].length
        });
        resp.write(ERROR_MSG[404]);
        resp.end();
    } else {
        fs.readFile(path.join(__dirname, res), function (e, s) {
            if (e) {
                resp.writeHead(500, {
                    "Content-Type"  : "text/plain",
                    "Content-Length": ERROR_MSG[500].length
                });
                resp.write(ERROR_MSG[500]);
                resp.end();
            } else {
                resp.writeHead(200, {
                    "Content-Type"  : EXT_CONTENT_TYPE[ext],
                    "Content-Length": s.length
                });
                resp.write(s);
                resp.end();
            }
        });
    }
});

var httpServer = server.listen(PORT, function() {});

var wss = new ws.Server({server:httpServer});
wss.on('connection', function connection(ws) { 
    webSocket = ws;
    console.log('Client connection established');
    ws.on('message', function incoming(message) {
         message = JSON.parse(message);
    
        var receiver = message.payload.receiver;
        
        message.payload.sender = "caf8";
        message.type = "agent_message";
        
        
       // console.log(getRecieversPort());
        tcpConn = net.connect(getRecieversPort(receiver), receiver + ".host.cs.st-andrews.ac.uk");
        tcpConn.write(JSON.stringify(message));

        
  //      ws.send(JSON.stringify(message));
        
        
        
	console.log('received: %s', message);
	
    });
    
    });

wss.on('error', function (err) {
    console.log(err);
});
   

var tcpServer = new net.createServer(function(socket) {

    socket.setEncoding('UTF-8');
    socket.on('error', function (err) {
	console.log(err);
    });

    socket.on('data', function (m) {
	try {
	    console.log(m);
	    content = JSON.parse(m);
	    if (content.type === "agent_message" || content.type === "delivery") {
            if(webSocket != null){
                console.log("sending message to client");
                webSocket.send(JSON.stringify(content));
            }else{console.log("web socket is null")}
      
       if (content.type === "agent_message"){
           
         var receiver = content.payload.sender;
           console.log(getRecieversPort(receiver));
           console.log(receiver);
        tcpConn = net.connect(getRecieversPort(), receiver + ".host.cs.st-andrews.ac.uk");
        
        content.type = "delivery";
        content.payload.success = true;
        content.payload.timestamp = Date.now();
        delete  content.payload.text;
        console.log(content);
        try{
        tcpConn.write(JSON.stringify(content));
        }catch(error){
            console.log(error);
        }
       }  
		console.log('recognised message');
	    }
	} catch (error) {
	    console.log("Message received does not match protocol");
	    console.log(error);
	}
	
    });

    socket.on('close', function () {

    });

}).listen(LISTEN_PORT);
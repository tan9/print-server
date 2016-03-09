# WebSocket Print Server

Simple WebSocket server that receives PDF content and print it out using Adobe Acrobat Reader. You can use this simple implementation to silent print PDF document to your default printer from web pages.


## Prerequisites
1. Windows environment.
2. Have [Adobe Acrobat Reader](https://get.adobe.com/reader/) installed. 
  * Tested on Acrobat Reader DC 2015 and Adobe Reader X.

## Interface
The server will listen on `localhost:9180`, you can access http://localhost:9180 to check whether the server is up or down.
You can then connect to the WebSocket server listen at `ws://localhost:9180/print`.

### Request Message
After the WebSocket connection is established successfully, you can send stringified JSON with following structure to print:

```json
{
  "id": "CORELEATION_ID",
  "body": "BASE64_ENCODED_PDF_DOCUMENT"
}
```

### Response Message
Server will respond with either messages:

In case of successful print:

```json
{
  "id": "CORELEATION_ID",
  "success": true,
  "message": ""
}
```

> *Note:* The return code of Foxit Reader process is alway 0. I can't found a simple way to make sure if document be printed successfully.

In case of failed to print:

```json
{
  "id": "CORELEATION_ID",
  "success": false,
  "message": "Fail reason..."
}
```

## Development

### Compiling print-server.go
1. Install Go as described [here](https://golang.org/doc/install).
2. Install [Gorilla WebSocket](https://github.com/gorilla/websocket) by executing `go get github.com/gorilla/websocket`.
3. Install [kardianos/service](https://github.com/kardianos/service) by executing `go get github.com/kardianos/service`.
4. Run `go run print-server.go` to start server.

### Compiling print.au3
1. Install [AutoIt](https://www.autoitscript.com/site/)
2. Compile `print.au3` using Aut2Exe to compile it to executable as described [here](https://www.autoitscript.com/autoit3/docs/intro/compiler.htm).

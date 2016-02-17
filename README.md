# WebSocket Print Server

Simple WebSocket server that receives PDF content and print it out using Foxit Reader. You can use this simple implementation to silet print PDF document to your default printer from web pages.


## Prerequisites
1. Must have [Foxit Reader](https://www.foxitsoftware.com/products/pdf-reader/) 6.2.3 Windows version installed at `C:\Program Files (x86)\Foxit Software\Foxit Reader\Foxit Reader.exe`. 
  * You can get that version at [Old Apps](http://www.oldapps.com/foxit_reader.php).
  * **DO NOT** use 7.x, the process will not be terminated automatically after silent printing.


## Interface
The server will listen on `localhost:9180`, you can access http://localhost:9180 to checek the server is up or not.
You can then connect to WebSocket server listen at `ws://localhost:9180/print`.

### Request Message
After the WebSocket connetion is estableashed successfully, you can send stringified JSON with following structure to print:

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
  "id": "CORELEATION_ID",
  "success": true,
  "message": ""

```
> *Note:* The return code of Foxit Reader process is alway 0. I can't found a simple way to make sure if document be printed successfully.

In case of failed to print:

```json
  "id": "CORELEATION_ID",
  "success": false,
  "message": "Fail reason..."
```

## Development
1. Install Go as described [here](https://golang.org/doc/install).
2. Install [Gorilla WebSocket](https://github.com/gorilla/websocket) using `go get github.com/gorilla/websocket`.
3. Run `go run print-server.go` to start server.

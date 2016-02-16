package main

import (
	"flag"
	"html/template"
	"log"
	"net/http"

	"encoding/json"
	"encoding/base64"

	"io/ioutil"

	"github.com/gorilla/websocket"
)

var addr = flag.String("addr", "localhost:9180", "http service address")

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		// allow all connections
		return true
	},
}

type Message struct {
	Id string
	Body string
}

type Response struct {
	Id string `json:"id"`
	Success bool `json:"success"`
	Message string `json:"message"`
}

func echo(w http.ResponseWriter, r *http.Request) {
	c, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Print("upgrade:", err)
		return
	}
	defer c.Close()
	for {
		_, message, err := c.ReadMessage()
		if err != nil {
			log.Println("read:", err)
			break
		}

		var m Message
		err = json.Unmarshal(message, &m)
		if err != nil {
			log.Println("unmarshal:", err)
			break
		}
		log.Printf("recv: %s", m.Id)


		pdf, err := base64.StdEncoding.DecodeString(m.Body)
		if (err != nil) {
			log.Println("decoding:", err)
			c.WriteJSON(Response{Id: m.Id, Success: false, Message: err.Error()});
			break
		}

		err = ioutil.WriteFile("xx.pdf", pdf, 0644);

		err = c.WriteJSON(Response{Id: m.Id, Success: true})
		if err != nil {
			log.Println("write:", err)
			break
		}
	}
}

func home(w http.ResponseWriter, r *http.Request) {
	homeTemplate.Execute(w, nil)
}

func main() {
	flag.Parse()
	log.SetFlags(0)
	http.HandleFunc("/echo", echo)
	http.HandleFunc("/", home)
	log.Fatal(http.ListenAndServe(*addr, nil))
}

var homeTemplate = template.Must(template.New("").Parse(`
<!DOCTYPE html>
<head>
<meta charset="utf-8">
<title>Print Server</title>
</head>
<body style="background-color: lightyellow;">
<h1>Print Server in service.</h1>
</body>
</html>
`))
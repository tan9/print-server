package main

import (
	"flag"
	"html/template"
	"log"
	"net/http"

	"encoding/json"
	"encoding/base64"

	"io/ioutil"
	"os"
	"os/exec"

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
	Id   string
	Body string
}

type Response struct {
	Id      string `json:"id"`
	Success bool `json:"success"`
	Message string `json:"message"`
}

func print(w http.ResponseWriter, r *http.Request) {
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

		f, err := ioutil.TempFile("", "print-server-pdf-");
		l, err := f.Write(pdf);
		if err != nil {
			log.Println("write file:", err)
			c.WriteJSON(Response{Id: m.Id, Success: false, Message: err.Error()});
			break
		}
		f.Close()
		log.Printf("write: %s of %d bytes", f.Name(), l)

		cmd := exec.Command("print.exe", f.Name())
		err = cmd.Start()
		if err != nil {
			log.Println("start cmd:", err)
			c.WriteJSON(Response{Id: m.Id, Success: false, Message: err.Error()});
			break
		}
		log.Printf("printing...")
		err = cmd.Wait()
		if err != nil {
			log.Println("print failed:", err)
			c.WriteJSON(Response{Id: m.Id, Success: false, Message: err.Error()});
			break
		}

		log.Println("print success:", m.Id)
		err = c.WriteJSON(Response{Id: m.Id, Success: true})
		if err != nil {
			log.Println("write:", err)
			break
		}
	}
}

func home(w http.ResponseWriter, r *http.Request) {
	homeTemplate.Execute(w, nil)
	log.Println("home page served.")
}

func main() {
	flag.Parse()

	f, err := os.OpenFile("print-server.log", os.O_RDWR | os.O_CREATE | os.O_APPEND, 0666)
	if err != nil {
		log.Fatalf("error opening file: %v", err)
	}
	defer f.Close()

	log.SetOutput(f)
	log.SetFlags(log.Ldate + log.Ltime + log.Lmicroseconds)

	http.HandleFunc("/print", print)
	http.HandleFunc("/", home)

	log.Printf("Server started-up and listening at %s.", *addr)
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

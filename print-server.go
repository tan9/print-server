package main

import (
	"flag"
	"html/template"
	"log"
	"net/http"
	"time"

	"encoding/json"
	"encoding/base64"

	"io/ioutil"
	"os"
	"os/exec"

	"github.com/gorilla/websocket"
	"github.com/kardianos/osext"
	"github.com/kardianos/service"
)

var logger service.Logger

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

// Program structures.
//  Define Start and Stop methods.
type program struct {
	exit chan struct{}
}

func (p *program) Start(s service.Service) error {
	if service.Interactive() {
		logger.Info("Running in terminal.")
	} else {
		logger.Info("Running under service manager.")
	}
	p.exit = make(chan struct{})

	// Start should not block. Do the actual work async.
	go p.run()
	return nil
}

func (p *program) run() {
	logger.Infof("Service running %v.", service.Platform())

	exePath, err := osext.ExecutableFolder()
	if err != nil {
		log.Fatal(err)
	}

	if _, err := os.Stat(exePath + "/logs"); os.IsNotExist(err) {
		err = os.Mkdir(exePath + "/logs", 0766)
		if err != nil {
			log.Fatalf("error creating logs folder: %v", err)
		}
	}

	ts := time.Now().Local().Format("2006-01-02")
	f, err := os.OpenFile(exePath + "/logs/print-server-" + ts + ".log", os.O_RDWR | os.O_CREATE | os.O_APPEND, 0666)
	if err != nil {
		log.Fatalf("error opening log file: %v", err)
	}
	defer f.Close()

	log.SetOutput(f)
	log.SetFlags(log.Ldate + log.Ltime + log.Lmicroseconds)

	http.HandleFunc("/print", print)
	http.HandleFunc("/", home)

	log.Printf("Server started-up and listening at %s.", *addr)
	log.Fatal(http.ListenAndServe(*addr, nil))
}

func (p *program) Stop(s service.Service) error {
	// Any work in Stop should be quick, usually a few seconds at most.
	log.Printf("Server stopping.")
	logger.Info("Service Stopping!")
	close(p.exit)
	return nil
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

		exePath, err := osext.ExecutableFolder()
		if err != nil {
			log.Println("failed to locate executable folder:", err)
			c.WriteJSON(Response{Id: m.Id, Success: false, Message: err.Error()});
			break
		}
		cmd := exec.Command(exePath + "/print.exe", f.Name())
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
	svcFlag := flag.String("service", "", "Control the system service.")
	flag.Parse()

	svcConfig := &service.Config{
		Name:        "GoPrintServer",
		DisplayName: "Go Print Server",
		Description: "Expose printer control as WebSocket server.",
	}

	prg := &program{}
	s, err := service.New(prg, svcConfig)
	if err != nil {
		log.Fatal(err)
	}
	logger, err = s.Logger(nil)
	if err != nil {
		log.Fatal(err)
	}
	errs := make(chan error, 5)
	logger, err = s.Logger(errs)
	if err != nil {
		log.Fatal(err)
	}

	go func() {
		for {
			err := <-errs
			if err != nil {
				log.Print(err)
			}
		}
	}()

	if len(*svcFlag) != 0 {
		err := service.Control(s, *svcFlag)
		if err != nil {
			log.Printf("Valid actions: %q\n", service.ControlAction)
			log.Fatal(err)
		}
		return
	}
	err = s.Run()
	if err != nil {
		logger.Error(err)
	}
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

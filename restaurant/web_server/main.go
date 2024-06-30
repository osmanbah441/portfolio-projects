package main

import (
	"log"
	"net/http"
)

func main() {
	fs := http.FileServer(http.Dir("./build/web"))

	http.Handle("/", fs)
	log.Println("starting server on http://127.0.0.1:8001")
	log.Fatal(http.ListenAndServe(":8001", nil))
}

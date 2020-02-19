package main

import (
	"fmt"
	"github.com/go-chi/chi"
	"github.com/go-chi/render"
	"log"
	"net/http"
	"time"
)

func handlerExample(w http.ResponseWriter, r *http.Request) {
	body := struct {
		Message string `json:"message"`
	}{ Message:"Hello from Go"}

	render.Status(r, http.StatusOK)
	render.JSON(w, r, body)

}

func main(){
	mux := chi.NewMux()
	mux.Get("/", handlerExample)
	
	server := &http.Server{
		Addr:              ":8080",
		Handler:           mux,
		TLSConfig:         nil,
		ReadTimeout:       10 * time.Second,
		ReadHeaderTimeout: 10 * time.Second,
		WriteTimeout:      10 * time.Second,
		IdleTimeout:       10 * time.Second,
	}

	fmt.Print("Starting Subscription service")
	if err := server.ListenAndServe(); err != nil {
		log.Fatal(err)
	}

}

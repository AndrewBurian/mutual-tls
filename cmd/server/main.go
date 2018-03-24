package main

import (
	"fmt"
	"net/http"

	"github.com/andrewburian/mutual-tls/pkg/crypto"
)

func main() {

	config := crypto.GetTLSConfig("server")
	if config == nil {
		panic("Config failed")
	}

	server := http.Server{
		Addr:      ":9001",
		TLSConfig: config,
	}

	err := server.ListenAndServeTLS("server.crt", "server.key")

	fmt.Println(err)
}

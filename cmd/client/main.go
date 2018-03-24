package main

import (
	"fmt"
	"net/http"

	"github.com/andrewburian/mutual-tls/pkg/crypto"
)

func main() {
	config := crypto.GetTLSConfig("client")
	if config == nil {
		panic("Config failed")
	}

	cli := http.Client{
		Transport: &http.Transport{
			TLSClientConfig: config,
		},
	}

	resp, err := cli.Get("https://localhost:9001/")
	if err != nil {
		panic(err)
	}

	fmt.Printf("Code response %s\n", resp.Status)
}

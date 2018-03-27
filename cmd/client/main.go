package main

import (
	"flag"
	"fmt"
	"net/http"

	"github.com/andrewburian/mutual-tls/pkg/crypto"
)

func main() {
	flagServer := flag.String("connect", "localhost:9001", "Server to connect to")
	flag.Parse()

	config := crypto.GetTLSConfig("client")
	if config == nil {
		panic("Config failed")
	}

	cli := http.Client{
		Transport: &http.Transport{
			TLSClientConfig: config,
		},
	}

	resp, err := cli.Get("https://" + *flagServer)
	if err != nil {
		panic(err)
	}

	fmt.Printf("Code response %s\n", resp.Status)
}

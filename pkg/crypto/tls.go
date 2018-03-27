package crypto

import (
	"crypto/tls"
	"crypto/x509"
	"fmt"
	"io/ioutil"
)

// GetTLSConfig sets up a TLS conn with cert, and ca
func GetTLSConfig(name string) *tls.Config {
	certFile := name + ".crt"
	keyFile := name + ".key"

	fmt.Printf("Loading keypair key=%s, cert=%s\n", keyFile, certFile)

	cert, err := tls.LoadX509KeyPair(name+".crt", name+".key")
	if err != nil {
		panic(err)
	}

	caBytes, err := ioutil.ReadFile("ca.crt")
	if err != nil {
		panic(err)
	}

	pool := x509.NewCertPool()
	if !pool.AppendCertsFromPEM(caBytes) {
		panic(err)
	}

	config := &tls.Config{
		Certificates: []tls.Certificate{cert},
		ClientCAs:    pool,
		RootCAs:      pool,
		ClientAuth:   tls.RequireAndVerifyClientCert,
	}

	return config
}

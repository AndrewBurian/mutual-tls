#!/bin/bash

# Make the CA key/cert
if [ ! -f cacert.pem ]; then
    printf "Making CA\n\n"

    # Generate the self signed cert
    openssl req -x509 -config openssl-ca.cnf -new -outform PEM -extensions ca_exts
fi

# Generate keys
if [[ ! -f cmd/server/server.key ]]; then openssl genrsa -out cmd/server/server.key 2048; fi
if [[ ! -f cmd/client/client.key ]]; then openssl genrsa -out cmd/client/client.key 2048; fi

# Generate requests
if [[ ! -f cmd/server/server.crt ]]; then
    printf "\n\nGenerating Server Cert\n\n"
    rm ca/server.csr
    openssl req -new -out ca/server.csr -key cmd/server/server.key <<EOF
CA
BC
Vancouver
Server
Rivendell.local
.
.
.
EOF
    openssl x509 -req -in ca/server.csr -CA ca/ca.crt -CAkey ca/ca.key -CAcreateserial -out cmd/server/server.crt
fi

if [[ ! -f cmd/client/client.crt ]]; then
    printf "\n\nGenerating Client Cert\n\n"
    rm ca/client.csr
    openssl req -new -out ca/client.csr -key cmd/client/client.key<<EOF
CA
BC
Vancouver
Client
client.local
.
.
.
EOF
    openssl x509 -req -in ca/client.csr -CA ca/ca.crt -CAkey ca/ca.key -CAcreateserial -out cmd/client/client.crt
fi

# Install CA cert
cp ca/ca.crt cmd/server/ca.crt
cp ca/ca.crt cmd/client/ca.crt
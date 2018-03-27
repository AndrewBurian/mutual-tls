#!/bin/bash

info() {
    printf "\e[32;1m$@\e[0m\n"
}

warn() {
    printf "\e[33;1m$@\e[0m\n"
}

error() {
    printf "\e[31;1m$@\e[0m\n"
}

# Make the CA key/cert
if [[ ! -f cacert.pem ]]; then
    info "Making CA"

    if [[ ! -d private ]]; then mkdir private; fi

    # Generate the self signed cert
    info "Generating CA private key and 5 year cert"
    warn "Generating unencrypted CA private key"
    openssl req -x509 -config openssl-ca.conf -new -outform PEM -extensions ca_exts -out cacert.pem -days 1825 -nodes
else
    info "Using existing CA cert"
fi

if [[ ! -d db ]]; then
    info "Setting up database"
    mkdir db
    echo "01" > db/serial
    touch db/certs
    touch db/crlnm
    mkdir db/certfiles
fi

# Generate server certificate
if [[ ! -f ../cmd/server/server.crt ]]; then
    info "Generating Server Key and Request"
    info "Generating Server CSR"
    openssl req \
        -config server.conf \
        -new \
        -out server.csr \
        -outform PEM \
        -keyout ../cmd/server/server.key \
        -keyform PEM \
        -nodes

    info "Signing CSR"
    openssl ca \
        -config openssl-ca.conf \
        -in server.csr \
        -out ../cmd/server/server.crt \
        -extensions basic_exts \
        -batch

    rm server.csr

else
    info "Using existing Server cert"
fi

if [[ ! -f ../cmd/client/client.crt ]]; then
    info "Generating Client Key and Cert"
    info "Generating Client CSR"
    openssl req \
        -config server.conf \
        -new \
        -out client.csr \
        -outform PEM \
        -keyout ../cmd/client/client.key \
        -keyform PEM \
        -nodes

    info "Signing CSR"
    openssl ca \
        -config openssl-ca.conf \
        -in client.csr \
        -out ../cmd/client/client.crt \
        -extensions basic_exts \
        -batch

    rm client.csr
else
    info "Using existing Client cert"
fi


# Install CA cert
info "Copying CA certs"
cp cacert.pem ../cmd/server/ca.crt
cp cacert.pem ../cmd/client/ca.crt
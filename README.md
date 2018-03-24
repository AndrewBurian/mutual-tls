# Mutual TLS sample
Quick demo of mutually authenticated TLS connection between an HTTP client and server.

### Setup
Run `./gentls.sh` from the root of the project to generate a cert authority, and client and server key-cert pairs.

The `cmd/server` and `cmd/client` binaries pull the named certs from their respective working directories.
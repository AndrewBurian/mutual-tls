# Mutual TLS sample
Quick demo of mutually authenticated TLS connection between an HTTP client and server.

### Setup
Run `./gentls.sh` from the ca directory to generate a cert authority, and client and server key-cert pairs.

The `cmd/server` and `cmd/client` binaries pull the named certs from their respective working directories.

To re-issue any cert, just delete the cert and re-run the gen command.
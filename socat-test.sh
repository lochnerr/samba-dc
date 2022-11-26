#!/bin/sh

# Generate a server certificate
# Perform the following steps on a trusted host where OpenSSL is installed. It might as well be the client or server host themselves.

# Prepare a basename for the files related to the server certificate:

FILENAME=server

# Generate a public/private key pair:

openssl genrsa -out $FILENAME.key 4096

# Generate a self signed certificate:

#penssl req -new -key $FILENAME.key -x509 -days 3653 -out $FILENAME.crt
openssl req -new -key $FILENAME.key -x509 -days 3650 -nodes -subj "/CN=socat-${FILENAME}" -out ${FILENAME}.crt

# You will be prompted for your country code, name etc.; you will want to set a commonname (e.g. socatssl), but you may quit other prompts with the enter key.

# Generate the PEM file by just appending the key and certificate files:

cat $FILENAME.key $FILENAME.crt >$FILENAME.pem

# The files that contain the private key should be kept secret, thus adapt their permissions:

chmod 600 $FILENAME.key $FILENAME.pem

# Now bring the file server.pem to the SSL server, e.g. to directory $HOME/etc/, using a secure channel like USB memory stick or SSH.
# Keep tight permissions on the file even on the target host, and remove all other instances of server.key and server.pem.

# Copy the trust certificate server.crt to the SSL client host, e.g. to directory $HOME/etc/; a secure channel is not required here, and the permissions are not critical.

# Generate a client certificate
# First prepare a different basename for the files related to the client certificate:

FILENAME=client

# Generate a public/private key pair:

openssl genrsa -out $FILENAME.key 4096

# Generate a self signed certificate:

#penssl req -new -key $FILENAME.key -x509 -days 3653 -out $FILENAME.crt
openssl req -new -key $FILENAME.key -x509 -days 3650 -nodes -subj "/CN=socat-${FILENAME}" -out ${FILENAME}.crt

# You will be prompted for your country code, name etc.; you will want to set a commonname (e.g. socatssl), but you may quit other prompts with the enter key.

# Generate the PEM file by just appending the key and certificate files:

cat $FILENAME.key $FILENAME.crt >$FILENAME.pem

# The files that contain the private key should be kept secret, thus adapt their permissions:

chmod 600 $FILENAME.key $FILENAME.pem

exit 1

# OpenSSL Server

# Instead of using a tcp-listen (tcp-l) address, we use openssl-listen (ssl-l) for the server, cert=... tells the program to the file containing
# its ceritificate and private key, and cafile=... points to the file containing the certificate of the peer; we trust clients only if they can
# proof that they have the related private key (OpenSSL handles this for us):

socat openssl-listen:4433,reuseaddr,cert=~/server.pem,cafile=~/client.crt echo

# After starting this command, socat should be listening on port 4433, but will require client authentication.

# OpenSSL Client

# Substitute your tcp-connect or tcp address keyword with openssl-connect or just ssl and here too add the cert, cafile, and openssl-commonname options:

#ocat stdio openssl-connect:server.domain.org:4433,openssl-commonname=socatssl,cert=$HOME/etc/client.pem,cafile=$HOME/etc/server.crt
socat stdio openssl-connect:192.168.33.7:4433,openssl-commonname=socatssl,cert=$HOME/etc/client.pem,cafile=$HOME/etc/server.crt

This command should establish a secured connection to the server process.

############################

socat -d -d TCP4-LISTEN:15432,fork     echo
socat -d -d stdio                      TCP4-CONNECT:192.168.33.7:15432


SAMBA:   socat -d -d TCP4-LISTEN:15432,fork                        UNIX-CONNECT:/var/lib/samba/ntp_signd/socket
Chrony:  socat -d -d UNIX-LISTEN:/var/lib/samba/ntp_signd/socket   TCP4-CONNECT:x.x.x.x:15432



#!/bin/bash

if [ ! -e "$(whoami).key" ]; then
  openssl req -nodes -x509 -sha256 -newkey rsa:4096 \
    -keyout "$(whoami).key" -out "$(whoami).crt" -days 365 \
    -subj "/C=US/ST=Texas/L=Leesburg/O=Clone Research Corp/OU=IT Dept/CN=$(whoami)"
fi 

# Also create a small text file to test the signing process on:

echo "Hello, World!" > sign.txt

# Sign the file

# Use the following command to sign the file. We actually take the sha256 hash of the file and sign that, all in one openssl command:

openssl dgst -sha256 -sign "$(whoami).key" -out sign.txt.sha256 sign.txt 

# This will result in a file sign.txt with the contents, and the file sign.txt.sha256 with the signed hash of this file.

# You can place the file and the public key ($(whoami).crt) on the internet or anywhere you like. Keep the 
# private key ($(whoami).key) very safe and private.


# Verify the signature

# To verify the signature, you need the specific certificate's public key. We can get that from the certificate using the following command:

# openssl x509 -in "$(whoami).crt"

# But that is quite a burden and we have a shell that can automate this away for us. The below command validates the file using the hashed signature:

openssl dgst -sha256 -verify  <(openssl x509 -in "$(whoami).crt"  -pubkey -noout) -signature sign.txt.sha256 sign.txt


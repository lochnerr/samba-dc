#!/bin/sh

# ca.key - ca key
# ca.pem - self-signed certificate
# client.key - client key
# client.csr - client certificate signing request
# client.pem - client certificate


# Creating a CA

# The two commands below will create CA private key and a corresponding self-signed certificate for you to sign the TLS client certificates with.

openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -aes-128-cbc -out ca.key
openssl req -new -x509 -days 365 -sha256 -key ca.key -out ca.pem

# The first command will ask you for a pass phrase for the key. It is used to protect access to the private key. You can decide to not use one by dropping the -aes-128-cbc option from the command.

# The second command will ask you to provide some details to be included in the certificate. Those details will be sent to the browser by 
# the web-server to let it know which client certificate to send back when authenticating.


# Server Configuration

# Upload the ca.pem that was just generated to your server. You should not upload the private key (ca.key).

# The following instructions are for Nginx

# ssl_client_certificate /path/to/ca.pem;
# ssl_verify_client on; # we require client certificates to access

# Assuming you already enabled TLS/SSL for the specific sub-domain, your configuration should look something like this:

# server {
#        server_name subdomain.example.com;
#
         # SSL configuration
         #
#        listen 443 ssl;
#        listen [::]:443 ssl;
#
#        ssl_certificate /etc/nginx/example.pem;
#        ssl_certificate_key /etc/nginx/example.key;
#
#        ssl_client_certificate /etc/ngingx/ca.pem;
#        ssl_verify_client on;

# After reloading the server, check that everything is configured correctly by trying to access your site via HTTPS. 
# It should report “400 Bad Request” and say that “No required SSL certificate was sent”.

# Creating a Client Certificate

# The following commands will create the private key used for the client certificate (client.key) and a corresponding 
# Certificate Signing Request (client.csr) which the owner of the CA certificate can sign (which in the case of this tutorial will be you).

openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out client.key
openssl req -new -key client.key -sha256 -out client.csr

# You will be asked again to provide some details, this time about you. Those details will be available to server once your browser 
# sends it the client certificate. You can safely leave the “challenge password” empty.

# You can add the flag -aes-128-cbc to the first command if you want the private key for the client certificate 
# to be encrypted. If you opt for it, you will be prompted for a pass phrase just like before.

# Signing a Client Certificate

# The next step is to sign the certificate signing request from the last step. It is a good practice to overview it
# and make sure all the details are as expected, so you do not sign anything you would not intend to.

openssl req -in client.csr -text -verify -noout | less

# If everything looks just fine, you can sign it with the following command.

openssl x509 -req -days 365 -in client.csr -CA ca.pem -CAkey ca.key \
    -set_serial 0x`openssl rand 16 -hex` -sha256 -out client.pem

# You will be prompted for your pass phrase for ca.key if you chose one in the first step.

# Installing Client Key

# Now comes the final part, where we take the signed client certificate, client.pem and combine it with the 
# private key so in can be installed in our browser.

openssl pkcs12 -export -in client.pem -inkey client.key -name "Sub-domain certificate for some name" -out client.p12


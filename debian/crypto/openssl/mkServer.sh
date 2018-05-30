#!/bin/bash
baseCA=`dirname "$0"`/ca
baseD=`dirname "$0"`/clients

name=$1

if [ "$1" == "" ]; then
  echo "./mkServer.sh <cn>"
  exit 0
fi

SUBJ="/C=DE/O=GS-SYS/CN=$name"

name=`echo "$name" | sed "s/ /_/g"`

if [ ! -d $baseD ]; then
 mkdir -p $baseD
fi

# More parameter
# -subj "/C=DE/ST=Berlin/L=Berlin/O=GS-SYS/OU=IT Department/CN=www.gs-sys.de"

#openssl req -new -sha512 -nodes -newkey rsa:4096 -keyout $baseD/$name.key -out $baseD/$name.csr \
openssl req -new -sha512 -nodes -newkey rsa:32768 -keyout $baseD/$name.key -out $baseD/$name.csr \
  -subj "$SUBJ"
openssl x509 -req -sha512 -CA $baseCA/CA.crt -CAkey $baseCA/CA.key -days 3650 -CAcreateserial \
   -CAserial $baseCA/CA.srl -extfile x509.ext -extensions server -in $baseD/$name.csr -out $baseD/$name.crt
rm $baseD/$name.csr
cat $baseD/$name.crt > $baseD/$name.pem
cat $baseD/$name.key >> $baseD/$name.pem

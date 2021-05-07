#!/bin/bash

VERSION=`curl https://golang.org/VERSION?m=text`
FILENAME="${VERSION}.linux-amd64.tar.gz"
URL="https://dl.google.com/go/${FILENAME}"
HASH=`curl ${URL}.sha256`

sed -i '###GOLANG_VERSION###/${VERSION}/g' Dockerfile
sed -i '###GOLANG_FILENAME###/${FILENAME}/g' Dockerfile
sed -i '###GOLANG_URL###/${URL}/g' Dockerfile
sed -i '###GOLANG_HASH###/${HASH}/g' Dockerfile

#!/bin/bash

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/../"
VERSION=`curl https://go.dev/VERSION?m=text`
PREV_VERSION=`cat ${ROOT}/.github/.previous_version`
FILENAME="${VERSION}.linux-amd64.tar.gz"
URL="https://dl.google.com/go/${FILENAME}"
HASH=`curl ${URL}.sha256`

if [ "$VERSION" != "$PREV_VERSION" ]; then
  cp $ROOT/.github/.Dockerfile.tmpl $ROOT/Dockerfile
  $RPL "###GOLANG_VERSION###" $VERSION $ROOT/Dockerfile
  $RPL "###GOLANG_FILENAME###" $FILENAME $ROOT/Dockerfile
  $RPL "###GOLANG_URL###" $URL $ROOT/Dockerfile
  $RPL "###GOLANG_HASH###" $HASH $ROOT/Dockerfile

  sed -i "s|###GOLANG_VERSION###|${VERSION}|g" Dockerfile
  sed -i "s|###GOLANG_FILENAME###|${FILENAME}|g" Dockerfile
  sed -i "s|###GOLANG_URL###|${URL}|g" Dockerfile
  sed -i "s|###GOLANG_HASH###|${HASH}|g" Dockerfile

  echo ${VERSION} > $ROOT/.github/.previous_version

  git -C $ROOT commit -m "Bump to ${VERSION}" Dockerfile .github/.previous_version
  git -C $ROOT push origin main
  git -C $ROOT tag -m "v${VERSION//go}" v${VERSION//go}
fi

FROM alpine:3.15
LABEL maintainer="Pål Sollie <sollie@sparkz.no>" org.opencontainers.image.source="https://github.com/sollie/golang-docker"

ARG BASE_URL="https://go.dev/dl"
ARG GO_VERSION
ARG VERSIONS_JSON="/tmp/go-versions.json"

ENV GOPATH="/go" \
    PATH="/go/bin:/opt/go/bin:$PATH"

RUN apk update && \
    apk add build-base \
        ca-certificates \
        curl \
        git \
        gzip \
        jq \
        libc6-compat \
        procps \
        tar \
        unzip \
        wget

RUN wget -nc -O ${VERSIONS_JSON} "${BASE_URL}/?mode=json&include=all" && \
    SHA256=$(jq '.[]| select((.version == "go${GO_VERSION}")).files[] | select((.os == "linux") and (.arch == "amd64") and (.kind == "archive"))| {sha256}' ${VERSIONS_JSON} | tr -d "{}"| sed '/^$/d'|tr -d " "| cut -f2 -d":") \
    FILENAME=$(jq '.[]| select((.version == "go${GO_VERSION}")).files[] | select((.os == "linux") and (.arch == "amd64") and (.kind == "archive"))| {filename}' ${VERSIONS_JSON} | tr -d "{}"| sed '/^$/d'|tr -d " "| cut -f2 -d":") \
    wget -nc -P /tmp/cache ${BASE_URL}/${FILENAME} && \
    echo "${SHA256} /tmp/cache/${FILENAME}" | sha256sum -c - && \
    tar -zxf /tmp/cache/${FILENAME} -P -C /opt && \
    rm -rf /tmp/cache/${FILENAME}
RUN mkdir -p "/go/src" "/go/bin" && chmod -R 777 "/go"

WORKDIR $GOPATH
CMD [ "sh" ]

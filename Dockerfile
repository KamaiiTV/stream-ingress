# srtlib Install Layer
FROM golang:1.17.7-alpine3.15 as build
RUN apk add --no-cache tcl pkgconfig cmake libressl-dev cmake gcc g++ make automake unzip linux-headers
ENV SRT_VERSION 1.4.4
WORKDIR /tmp
RUN wget https://github.com/Haivision/srt/archive/refs/tags/v${SRT_VERSION}.zip
RUN unzip v${SRT_VERSION}.zip
WORKDIR /tmp/srt-${SRT_VERSION}
RUN ./configure
RUN make
RUN apk del linux-headers unzip automake make g++ gcc cmake
# Golang build layer
RUN mkdir /app
COPY . /app
WORKDIR /app
RUN go mod download
RUN go build .
CMD ["/app/stream-ingress"]
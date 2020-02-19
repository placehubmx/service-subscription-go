# Dockerfile References: https://docs.docker.com/engine/reference/builder/

# Start from builder
FROM golang:alpine as builder

# Setup go mod env variable
# ENV GO111MODULE=on

# Add maintainer information
LABEL maintainer="Alonso R <aruiz@damascus-engineering.com>"

# Install git
RUN apk update && apk add --no-cache git

# Set the current working directory inside container
WORKDIR /go/src/github.com/placehubmx/service-subscription-go/

# Copy go mod files
COPY go.mod .
COPY go.sum .

# Download all external dependencies
RUN go mod download

# Copy current's directory files to Docker builder workdir
COPY . .

# Build application
RUN cd cmd/subscription && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o ../../build/subscription .

##### PRODUCTION STAGE CONTAINER
FROM alpine:latest as prod

# SSL Certs
RUN apk --no-cache add ca-certificates

# Setup prod workdir to root
WORKDIR /root/

# Copy compiled binaries to production container workdir
COPY --from=builder /go/src/github.com/placehubmx/service-subscription-go/build .

# Copy environment dotenv file to production container
COPY --from=builder /go/src/github.com/placehubmx/service-subscription-go/.env .

# Expose used port
EXPOSE 8080

# Command to run binary
CMD ["./subscription"]
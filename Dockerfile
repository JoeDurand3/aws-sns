# Step 1: Modules caching
FROM golang:1.18.1-alpine3.14 as modules
COPY go.mod go.sum /modules/
WORKDIR /modules
RUN go mod download

# Step 2: Builder
FROM golang:1.18.1-alpine3.14 as builder
COPY --from=modules /go/pkg /go/pkg
#COPY . /app
WORKDIR /
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build main.go

##
## Deploy
##
FROM gcr.io/distroless/base-debian10
CMD ["/main"]
# syntax=docker/dockerfile:1

FROM golang:1.23
WORKDIR /app
COPY go.mod ./
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -o /docker-gs-ping
RUN mkdir bug-report

CMD ["/docker-gs-ping"]
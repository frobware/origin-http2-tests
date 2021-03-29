FROM golang:1.16-alpine AS build

WORKDIR /go/src/
COPY . .
RUN CGO_ENABLED=0 go build -x -v -o /bin/http2-server ./http2/server.go
RUN CGO_ENABLED=0 go build -x -v -o /bin/grpc-server ./grpc/server/server.go
RUN CGO_ENABLED=0 go build -x -v -o /bin/grpc-client ./grpc/client/client.go

FROM scratch
COPY --from=build /bin/http2-server /bin/http2-server
COPY --from=build /bin/grpc-server /bin/grpc-server
COPY --from=build /bin/grpc-client /bin/grpc-client

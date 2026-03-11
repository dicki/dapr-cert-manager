FROM golang:1.24 AS builder

WORKDIR /workspace

COPY go.mod go.sum ./
RUN go mod download

COPY cmd/ cmd/
COPY pkg/ pkg/

RUN CGO_ENABLED=0 go build -o dapr-cert-manager ./cmd

FROM gcr.io/distroless/static:nonroot

COPY --from=builder /workspace/dapr-cert-manager /dapr-cert-manager

USER 1001:1001

ENTRYPOINT ["/dapr-cert-manager"]

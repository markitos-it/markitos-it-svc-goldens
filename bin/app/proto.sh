#!/bin/bash
set -e

echo "== protoc version =="
protoc --version

echo "== include dirs check =="
if [ -f /usr/include/google/protobuf/timestamp.proto ]; then
  ls -la /usr/include/google/protobuf/timestamp.proto
else
  echo "== /usr/include/google/protobuf/timestamp.proto not found =="
fi

if [ -f /usr/local/include/google/protobuf/timestamp.proto ]; then
  ls -la /usr/local/include/google/protobuf/timestamp.proto
else
  echo "== /usr/local/include/google/protobuf/timestamp.proto not found =="
fi

echo "== generating protobuf go files =="
protoc -I. -I/usr/include -I/usr/local/include \
  --go_out=. --go_opt=paths=source_relative \
  --go-grpc_out=. --go-grpc_opt=paths=source_relative \
  proto/golden.proto

echo "== generated files =="
ls -la proto
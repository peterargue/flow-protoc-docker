# Build Flow Access API

Build the protoc docker container
```
# For x86 machines
docker build -t protoc .

# For arm64 machines
docker build -t protoc --build-arg GOARCH=arm64 .
```

Clone `onflow/flow` repo locally
```
git clone git@github.com:onflow/flow.git
```

Generate proto files
```
FLOW_PROTOBUF_PATH=/Users/pargue/dev/onflow/flow/protobuf
docker run --rm -v ${FLOW_PROTOBUF_PATH}:/src -ti protoc -c "make generate"
```

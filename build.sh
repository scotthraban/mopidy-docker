docker buildx build \
  --build-arg UID=1049 \
  --platform linux/arm64/v8,linux/amd64 \
  --push \
  --tag docker-registry.hraban.com/mopidy:latest \
  --tag docker-registry.hraban.com/mopidy:1.2 \
  .

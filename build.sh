docker buildx build \
  --build-arg UID=1049 \
  --platform linux/arm64/v8,linux/amd64 \
  --push \
  --tag docker-registry.example.com/mopidy:latest \
  --tag docker-registry.example.com/mopidy:1.0 \
  .

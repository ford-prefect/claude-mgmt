default_uid := `id -u`

# Build the claude-code container image
build uid=default_uid:
    podman build --build-arg UID={{uid}} -t claude-code .

# Run Claude Code in a sandboxed container
run directory:
    ./claude-sandbox "{{directory}}"

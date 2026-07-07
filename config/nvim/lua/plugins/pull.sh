#!/bin/bash
# Download containers with the lsp servers

for container in nas.local:5000/ruff \
  nas.local:5000/rustfmt \
  nas.local:5000/jq \
  nas.local:5000/clang-format \
  nas.local:5000/shfmt \
  nas.local:5000/tex-fmt \
  nas.local:5000/bibtex-tidy; do
  podman pull "$container"
done

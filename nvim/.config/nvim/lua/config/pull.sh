#!/bin/sh

for container in nas.local:5000/clangd:latest nas.local:5000/pyright:latest \
  nas.local:5000/asm-lsp \
  nas.local:5000/jsonls \
  nas.local:5000/bashls \
  nas.local:5000/ltex-ls-plu \
  nas.local:5000/rust-analyzer \
  nas.local:5000/marksman-lsp; do
  podman pull "$container"
done

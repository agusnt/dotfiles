# How to install

I know that you are using the latest version of Debian stable.

## Before anything

Install `cargo` and `npm`:

```bash
curl https://sh.rustup.rs -sSf | sh

sudo apt install npm
```


## LSP server

Install the LSP servers:

```bash
sudo apt install clangd

npm install -g pyright vscode-json-languageserver vscode-html-languageservice bash-language-server

cargo install asm-lsp

cargo install --git https://github.com/latex-lsp/texlab texlab
```


## Formatters

## Lint

```bash
sudo apt install shellcheck
```

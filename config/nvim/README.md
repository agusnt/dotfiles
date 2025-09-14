# How to install

I know that you are using the latest version of Debian Trixie.

This should work with the nvim 0.10, when nvim 0.11 (or newer version) hits de Debian repository (even backports) I will update to it. 

## Before anything

Install `cargo` and `npm`:

```bash
curl https://sh.rustup.rs -sSf | sh

sudo apt install npm

npm install -g tree-sitter-cli
```

### Recommended

Modified `.npmrc` to install packages to the user instead of global, adding: `prefix=~/.local/`


## LSP server

Install the LSP servers:

```bash
sudo apt install clangd gopls

npm install -g vscode-json-languageserver vscode-html-languageservice bash-language-server pyright

cargo install asm-lsp harper-ls

cargo install --git https://github.com/latex-lsp/texlab texlab
```

## Formatters

```bash

sudo apt install jq clang-format shfmt python3-autopep8

npm install -g bibtex-tidy

curl -LsSf https://astral.sh/ruff/install.sh | sh

```


## Lint

```bash
sudo apt install shellcheck clang-tidy
```


# Road to the new versions of NVIM

## 0.11

* Modified the nvim-lsp plugin, since 0.11 is easier to configure lsp servers.

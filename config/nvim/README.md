# How to install

I know that you are using the latest version of Debian Trixie.

This should work with the NVIM 0.10, when nvim 0.11 hits de Debian repository (even backports) I will update to it. 

## Before anything

Install `cargo` and `npm`:

```bash
curl https://sh.rustup.rs -sSf | sh

sudo apt install npm

sudo npm install -g tree-sitter-cli
```


## LSP server

Install the LSP servers:

```bash
sudo apt install clangd

sudo npm install -g vscode-json-languageserver vscode-html-languageservice bash-language-server pyright

cargo install asm-lsp

cargo install --git https://github.com/latex-lsp/texlab texlab
```

### LTex-LS

Download the package from [here](https://github.com/ltex-plus/ltex-ls-plus/releases/tag/18.5.1).

```bash
# Extract it
tar -xf ltex-ls-plus*.tar.gz

# Copy the binary
sudo cp ltex-ls-plus*/ /opt

sudo ln -s /opt/ltex-ls-plus-18.5.1/bin/ltex-ls-plus /usr/local/bin/ltex-ls
```


## Formatters

```bash

sudo apt install jq clang-format shfmt python3-autopep8

sudo npm install -g bibtex-tidy ruff

```


## Lint

```bash
sudo apt install shellcheck
```


# Road to new versions of NVIM

## 0.11

* Modified the nvim-lsp plugin, since 0.11 is easier to configure lsp servers.

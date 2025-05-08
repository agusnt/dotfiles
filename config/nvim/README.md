# How to install

I know that you are using the latest version of Debian stable.

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

sudo npm install -g vscode-json-languageserver vscode-html-languageservice bash-language-server

cargo install asm-lsp

cargo install --git https://github.com/latex-lsp/texlab texlab

pip install --user --break-system-packages pyright
```

### LTex-LS

Download the package from [here](https://github.com/ltex-plus/ltex-ls-plus/releases/tag/18.5.1).

```bash

# Install OpenJDK 21
wget https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.3%2B9/OpenJDK21U-jdk_x64_linux_hotspot_21.0.3_9.tar.gz
sudo tar -xzf OpenJDK21U-jdk_x64_linux_hotspot_21.0.3_9.tar.gz -C /opt/
sudo update-alternatives --install /usr/bin/java java /opt/jdk-21.0.3+9/bin/java 1000
sudo update-alternatives --install /usr/bin/javac javac /opt/jdk-21.0.3+9/bin/javac 1000

# Extract it
tar -xf ltex-ls-plus*.tar.gz

# Copy the binary
sudo cp ltex-ls-plus*/bin/ltex-ls-lus /usr/local/bin/
```


## Formatters

```bash

sudo apt install jq clang-format shfmt

sudo npm install -g bibtex-tidy

pip install --user --break-system-packages autopep8 ruff
```


## Lint

```bash
sudo apt install shellcheck
```


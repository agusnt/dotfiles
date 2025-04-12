# How to install

I know that you are using the latest version of Debian stable, zshrc, and nvim >= 0.11.

## Before anything

Install `cargo` and `npm`:

```bash
curl https://sh.rustup.rs -sSf | sh

sudo apt install npm
```


Change the global where npm install stuff

```bash
mkdir ~/.npm-global

npm config set prefix '~/.npm-global'

echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.zshrc
```



## LSP server

Install the LSP servers:

```bash
sudo apt install clangd

npm install -g pyright vscode-json-languageserver vscode-html-languageservice bash-language-server

cargo install asm-lsp

cargo install --git https://github.com/latex-lsp/texlab texlab
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

sudo apt install jq clang-format

npm install -g bibtex-tidy

pip install --user --break-system-packages beautysh autopep8
```


## Lint

```bash
sudo apt install shellcheck
```


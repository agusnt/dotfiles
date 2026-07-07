#!/bin/bash
# Automatic download and install the treesitter parsers

# Install parsers
PATH_PARSERS="$HOME/.local/tree-sitter-parsers"
mkdir -p "$PATH_PARSERS"
cd "$PATH_PARSERS" || exit 1

declare -A parsers=(
  ["python"]="https://github.com/tree-sitter/tree-sitter-python"
  ["c"]="https://github.com/tree-sitter/tree-sitter-c"
  ["markdown"]="https://github.com/tree-sitter-grammars/tree-sitter-markdown"
  ["sway"]="https://github.com/FuelLabs/tree-sitter-sway"
  ["zsh"]="https://github.com/georgeharker/tree-sitter-zsh"
  ["awk"]="https://github.com/Beaglefoot/tree-sitter-awk"
  ["bash"]="https://github.com/tree-sitter/tree-sitter-bash"
  ["bibtex"]="https://github.com/latex-lsp/tree-sitter-bibtex"
  ["comment"]="https://github.com/stsewd/tree-sitter-comment"
  ["containerfile"]="https://github.com/wharflab/tree-sitter-containerfile"
  ["cpp"]="https://github.com/tree-sitter/tree-sitter-cpp"
  ["diff"]="https://github.com/tree-sitter-grammars/tree-sitter-diff"
  ["go"]="https://github.com/tree-sitter/tree-sitter-go"
  ["gpg"]="https://github.com/tree-sitter-grammars/tree-sitter-gpg-config"
  ["html"]="https://github.com/tree-sitter/tree-sitter-html"
  ["jq"]="https://github.com/nverno/tree-sitter-jq"
  ["json"]="https://github.com/tree-sitter/tree-sitter-json"
  ["json5"]="https://github.com/Joakker/tree-sitter-json5"
  ["latex"]="https://github.com/latex-lsp/tree-sitter-latex"
  ["lua"]="https://github.com/tree-sitter-grammars/tree-sitter-lua"
  ["make"]="https://github.com/tree-sitter-grammars/tree-sitter-make"
  ["norg_meta"]="https://github.com/nvim-neorg/tree-sitter-norg-meta"
  ["norg"]="https://github.com/nvim-neorg/tree-sitter-norg"
  ["query"]="https://github.com/tree-sitter-grammars/tree-sitter-query"
  ["regex"]="https://github.com/tree-sitter/tree-sitter-regex"
  ["dockerfile"]="https://github.com/camdencheek/tree-sitter-dockerfile"
)

for parser in "${!parsers[@]}"; do
  [ -d "$parser" ] && continue
  echo "Pulling $parser"
  git clone "${parsers[$parser]}" "$parser" >/dev/null 2>&1
  cd "$parser" || exit 1
  echo "  Installing $parser"

  # Special cases
  if [[ "$parser" == "cpp" ]]; then
    npm install tree-sitter-c > /dev/null 2>&1
  elif [[ "$parser" == "markdown" ]]; then
    make
    cp tree-sitter-markdown/libtree-sitter-markdown.so markdown.so 
    cp tree-sitter-markdown-inline/libtree-sitter-markdown-inline.so markdown-inline.so 
    cd ..
    continue
  elif [[ "$parser" == "norg" ]]; then
    gcc -c src/parser.c -o parser.o -fPIC -I./src
    g++ -c src/scanner.cc -o scanner.o -fPIC -std=c++11 -I./src
    g++ -shared -o norg.so parser.o scanner.o -fPIC
    cd ..
    continue
  fi

  tree-sitter generate || exit 1
  tree-sitter build || exit 1
  [ -f "parser.so" ] && mv parser.so "${parser}".so
  cd ..
done

# tree-sitter-rnoweb

Tree-sitter grammar for R noweb (Sweave) documents. Parses `.Rnw` and `.rnoweb` files containing LaTeX with embedded R code chunks and inline `\Sexpr{}` expressions.

## Neovim setup

### 1. Symlink query files

```bash
mkdir -p ~/.config/nvim/queries/rnoweb/
ln -sf ~/path/to/tree-sitter-rnoweb/queries/highlights.scm ~/.config/nvim/queries/rnoweb/highlights.scm
ln -sf ~/path/to/tree-sitter-rnoweb/queries/injections.scm ~/.config/nvim/queries/rnoweb/injections.scm
```

Replace `~/path/to/tree-sitter-rnoweb` with the actual path to this repo.

### 2. Compile the parser

```bash
mkdir -p ~/.local/share/nvim/site/parser/
gcc -O2 -shared \
  -I src \
  src/parser.c src/scanner.c \
  -o ~/.local/share/nvim/site/parser/rnoweb.so
```

### 3. Register the filetype

Tell Neovim to treat `.Rnw` and `.rnoweb` files as `rnoweb`. This is required for ALL `rnoweb` features — highlighting, formatting, injections, etc. Without it, nothing below will work.

```lua
vim.filetype.add({
  extension = { Rnw = "rnoweb", rnoweb = "rnoweb" },
})
```

### 4. Register the parser

Point tree-sitter to the compiled grammar:

```lua
vim.treesitter.language.add("rnoweb", {
  path = vim.fn.expand("~/.local/share/nvim/site/parser/rnoweb.so"),
})
```

### 5. Verify

Open a `.Rnw` file and run `:InspectTree`. You should see proper syntax nodes with no red `ERROR` tags.

## Installation from GitHub release

Download `tree-sitter-rnoweb.wasm` or `tree-sitter-rnoweb.tar.gz` from the [latest release](https://github.com/urtzienriquez/tree-sitter-rnoweb/releases).

## Formatting

### literateR-fmt

This repo ships a formatter at `formatters/literateR-fmt` that formats LaTeX while preserving R code chunks and inline expressions intact. It handles:

- Rnoweb chunks (`<<...>>=` ... `@`)
- R Markdown chunks (`` ```{r} `` ... `` ``` ``)
- YAML front matter

**Requirements:** `latexindent` must be installed and on your `PATH`.

```bash
# Install via your system package manager, or:
# tlmgr install latexindent
```

**Usage:**

```bash
literateR-fmt file.Rnw          # format in-place
literateR-fmt < input.Rnw > output.Rnw   # stdin/stdout
```

Set `LITERATE_R_LATEXINDENT` to override the latexindent path.

### Neovim (conform.nvim)

Requires the filetype registration from [step 3](#3-register-the-filetype) above. Without `vim.filetype.add`, conform won't recognize `.Rnw`/`.rnoweb` files.

```lua
require("conform").setup({
  formatters = {
    literateR_fmt = {
      command = "literateR-fmt",
      stdin = true,
    },
  },
  formatters_by_ft = {
    rnoweb = { "literateR_fmt" },
  },
})
```

# My Neovim Config

Personal Neovim configuration using Lazy.nvim as the plugin manager.

## Usage

This configuration uses the `NVIM_APPNAME` variable to load a separate config.

```bash
NVIM_APPNAME=my_neovim nvim
```

### Create an alias (optional)

Add this to your `.bashrc` or `.zshrc`:

```bash
alias mvim="NVIM_APPNAME=my_neovim nvim"
```

Then reload your shell:

```bash
source ~/.bashrc  # or source ~/.zshrc
```

Then use:

```bash
mvim file.txt
```

## Installed Plugins

- **lazy.nvim** - Plugin manager
- **bamboo.nvim** - Theme
- **nvim-treesitter** - Syntax highlighting
- **mason.nvim** - LSP/formatter/linter manager
- **nvim-lspconfig** - LSP configuration
- **mini.nvim** - Utilities (statusline, etc.)

## Useful Commands

| Command | Description |
|---------|-----------|
| `:Mason` | Opens the LSP package manager |
| `:Lazy` | Opens the plugin manager |
| `<space>vs` | Sources the current file |
| `<space>vx` | Executes the current Lua line or visual selection |

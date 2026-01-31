# My Neovim Config

Configuração personalizada do Neovim usando Lazy.nvim como gerenciador de plugins.

## Como usar

Esta configuração usa a variável `NVIM_APPNAME` para carregar uma config separada.

```bash
NVIM_APPNAME=my_neovim nvim
```

### Criar um alias (opcional)

Adicione ao seu `.bashrc` ou `.zshrc`:

```bash
alias mvim="NVIM_APPNAME=my_neovim nvim"
```

Depois recarregue o shell:

```bash
source ~/.bashrc  # ou source ~/.zshrc
```

Agora basta usar:

```bash
mvim arquivo.txt
```

## Plugins instalados

- **lazy.nvim** - Gerenciador de plugins
- **bamboo.nvim** - Tema
- **nvim-treesitter** - Syntax highlighting
- **mason.nvim** - Gerenciador de LSP/formatters/linters
- **nvim-lspconfig** - Configuração de LSP
- **mini.nvim** - Utilitários (statusline, etc.)

## Comandos úteis

| Comando | Descrição |
|---------|-----------|
| `:Mason` | Abre o gerenciador de pacotes LSP |
| `:Lazy` | Abre o gerenciador de plugins |
| `<space><space>x` | Executa o arquivo atual como Lua |
| `<space>x` | Executa a linha/seleção como Lua |

# 🚀 Neovim Configuration

A performance-optimized Neovim configuration designed for Laravel/Vue.js full-stack development with Docker support.

## ✨ Features

- **🐳 Docker Integration** - Seamless Laravel development with Docker containers
- **🎯 Smart Testing** - Neotest integration with artisan alias support
- **⚡ Performance Optimized** - Aggressive startup optimizations and LSP resource management
- **🔧 Modular Architecture** - Clean, organized plugin structure
- **🎨 Laravel/Vue Focus** - Specialized tools for modern web development

## 📁 Structure

```
lua/
├── core/           # Core Neovim settings
│   ├── options.lua # Vim options and settings
│   └── keymaps.lua # Basic keymaps and core functionality
├── modules/        # Plugin modules by functionality
│   ├── lsp/        # Language Server Protocol
│   ├── completion/ # Completion engine (nvim-cmp)
│   ├── editor/     # Navigation and editing tools
│   ├── ui/         # Interface and appearance
│   ├── git/        # Git integration
│   ├── tools/      # Development tools
│   └── misc/       # Utility plugins
└── utils/          # Custom utilities
    ├── snippets/   # Code snippets
    └── laravel-testing.lua # Laravel testing integration
```

## ⚙️ Installation

1. **Backup existing config:**
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone this configuration:**
   ```bash
   git clone <your-repo> ~/.config/nvim
   ```

3. **Install dependencies:**
   - Neovim >= 0.9.0
   - Git
   - Node.js (for LSP servers)
   - PHP (for Laravel development)
   - Docker & Docker Compose (optional)

4. **Start Neovim:**
   ```bash
   nvim
   ```
   Plugins will be automatically installed via lazy.nvim.

## 🔧 Core Settings

- **Leader Key:** `<Space>`
- **Local Leader:** `,`
- **Indentation:** 2 spaces
- **Line Length:** 120 characters
- **Theme:** Gruvbox Dark (hard contrast)

## ⌨️ Key Mappings

### 🎯 Core Navigation

| Key | Description |
|-----|-------------|
| `<C-h/j/k/l>` | Navigate between panes |
| `<leader>e` | Quit current buffer |
| `<leader>q` | Quit all buffers |
| `<leader>b` | Switch to alternate buffer |
| `<C-t>` | New tab |
| `<C-left/right>` | Move tab left/right |
| `<leader>T` | Close current tab |

### 📁 File Navigation

| Key | Description |
|-----|-------------|
| `<leader>-` | Open file explorer (Oil) |
| `<leader>ff` | Find files (Telescope) |
| `<leader>fg` | Live grep (Telescope) |
| `<leader>fb` | Find buffers (Telescope) |
| `<leader>fh` | Find help tags (Telescope) |
| `<C-e>` | Toggle Harpoon quick menu |

### 🧪 Testing (Neotest + Laravel)

| Key | Description |
|-----|-------------|
| `<leader>tt` | Run nearest test |
| `<leader>tf` | Run file tests |
| `<leader>ta` | Run all tests |
| `<leader>tu` | Run unit tests |
| `<leader>tF` | Run feature tests |
| `<leader>tr` | Show test results |
| `<leader>ts` | Toggle test summary |
| `<leader>to` | Toggle test output panel |

**Commands:**
- `:TestStatus` - Show testing environment status
- `:TestPrepareDB` - Prepare test database (migrate)
- `:TestRefreshDB` - Refresh test database (migrate + seed)

### 🔍 LSP & Code Navigation

| Key | Description |
|-----|-------------|
| `<leader>gd` | Go to definition |
| `<leader>gr` | Find references |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename symbol |
| `<leader>lf` | Format with LSP |
| `K` | Hover documentation |
| `[d` / `]d` | Navigate diagnostics |
| `<leader>gl` | Show line diagnostics |
| `<leader>ld` | List all diagnostics |
| `<leader>dv` | Toggle virtual text |

### 🔧 LSP Resource Management

| Key | Description |
|-----|-------------|
| `<leader>ls` | LSP status and resources |
| `<leader>lr` | Restart heavy LSP servers |
| `<leader>lk` | Stop non-essential LSP |
| `<leader>le` | Emergency stop all LSP |

### 🎨 Tailwind CSS Control

| Key | Description |
|-----|-------------|
| `<leader>tws` | Start Tailwind LSP |
| `<leader>twk` | Stop Tailwind LSP |
| `<leader>twr` | Restart Tailwind LSP |
| `<leader>twt` | Toggle Tailwind LSP |
| `<leader>twp` | Enable performance mode |
| `<leader>twi` | Show Tailwind status |

**Commands:**
- `:TailwindStart` / `:TailwindStop` / `:TailwindRestart`
- `:TailwindToggle` / `:TailwindStatus`
- `:TailwindPerformanceMode` / `:TailwindNormalMode`

### ✏️ Completion & Snippets

| Key | Description |
|-----|-------------|
| `<Tab>` | Expand snippet or jump forward |
| `<S-Tab>` | Jump backward in snippet |
| `<C-Space>` | Trigger completion |
| `<C-e>` | Close completion menu |
| `<CR>` | Confirm completion |
| `<leader>ss` | Reload snippets |

### 🔄 Git Integration

| Key | Description |
|-----|-------------|
| `<leader>gs` | Git status (Fugitive) |
| `<leader>gc` | Git commit |
| `<leader>gp` | Git push |
| `<leader>gl` | Git log |
| `<leader>gb` | Git blame |
| `<leader>gd` | Git diff |

### 🐛 Debugging (DAP)

| Key | Description |
|-----|-------------|
| `<F5>` | Start/continue debugging |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dt` | Toggle DAP UI |
| `<leader>dl` | Run last debug config |

### 📝 Note Taking (Obsidian)

| Key | Description |
|-----|-------------|
| `<leader>on` | New note |
| `<leader>of` | Quick switch notes |
| `<leader>od` | Daily note |
| `<leader>ol` | Link to existing note |
| `<leader>oL` | Link to new note |
| `<leader>os` | Search vault |
| `<leader>ob` | Show backlinks |

### 🖥️ Terminal

| Key | Description |
|-----|-------------|
| `<C-\>` | Toggle terminal |
| `<Esc>` | Exit insert mode in terminal |
| `q` | Close terminal (in normal mode) |

### 📖 Documentation & Help

| Key | Description |
|-----|-------------|
| `<leader>hc` | Open config documentation |
| `<leader>ch` | Open cheatsheet |

## 🛠️ Plugin Configuration

### Core Plugins

- **Plugin Manager:** [lazy.nvim](https://github.com/folke/lazy.nvim)
- **Colorscheme:** [gruvbox.nvim](https://github.com/ellisonleao/gruvbox.nvim)
- **File Explorer:** [oil.nvim](https://github.com/stevearc/oil.nvim)
- **Fuzzy Finder:** [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- **Status Line:** [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)

### LSP & Development

- **LSP:** [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- **LSP Installer:** [mason.nvim](https://github.com/williamboman/mason.nvim)
- **Completion:** [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- **Snippets:** [LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- **Testing:** [neotest](https://github.com/nvim-neotest/neotest)
- **Debugging:** [nvim-dap](https://github.com/mfussenegger/nvim-dap)

### Language Support

**PHP/Laravel:**
- LSP: PHPActor (optimized)
- Formatter: Laravel Pint
- Testing: PHPUnit via Neotest
- Snippets: Custom Laravel snippets

**JavaScript/TypeScript/Vue:**
- LSP: tsserver, Volar (Vue)
- Formatter: Prettier
- Testing: Vitest, Jest
- Snippets: Vue 3 Composition API

**Other Languages:**
- Python: Pyright
- JSON/HTML: Built-in support
- CSS: Tailwind CSS LSP

## 🐳 Docker Integration

### Testing Priority Order
1. **Artisan alias** (preferred - uses your container setup)
2. **Docker container** (`{COMPOSE_PROJECT}-php-fpm-debug`)
3. **System PHP** (local fallback)

### Container Detection
- Reads `COMPOSE_PROJECT` from `.env` file
- Automatically detects running containers
- Falls back gracefully to system tools

## ⚡ Performance Features

### Startup Optimizations
- Lazy loading for all plugins
- Disabled unnecessary built-in plugins
- Aggressive caching enabled
- Minimal startup requirements

### LSP Resource Management
- Memory limits on Node.js-based LSPs (1GB for tsserver)
- Auto-restart heavy servers at 500MB usage
- Diagnostic limiting (50 per buffer)
- Performance monitoring every 30 seconds

### Disabled for Performance
- PHPStan, Psalm (can be re-enabled)
- CSS/HTML LSP (uses Tailwind instead)
- Virtual text limited to warnings/errors

## 🔧 Configuration

### Environment Variables
The configuration respects these environment variables:
- `COMPOSE_PROJECT` - Docker project name
- `APP_ENV` - Application environment (auto-set to "testing" for tests)

### Custom Settings
Key settings can be modified in:
- `lua/core/options.lua` - Vim options
- `lua/core/keymaps.lua` - Key mappings
- `lua/modules/lsp/servers.lua` - LSP server configurations

## 🚨 Troubleshooting

### Testing Issues
1. **PDO Driver Errors:**
   ```bash
   # Ensure containers are running
   docker-compose up -d
   
   # Check test environment
   :TestStatus
   
   # Prepare test database
   :TestPrepareDB
   ```

2. **Artisan Alias Not Working:**
   - Ensure your `artisan` alias is properly set up
   - Try `:TestStatus` to check detection
   - Verify containers are running

### LSP Issues
1. **High Memory Usage:**
   ```vim
   :LspStatus          " Check memory usage
   :LspRestart         " Restart heavy servers
   :LspEmergencyStop   " Nuclear option
   ```

2. **Slow Performance:**
   - Check LSP resource usage with `:LspStatus`
   - Consider enabling Tailwind performance mode
   - Disable non-essential LSP servers

### Plugin Issues
1. **Lazy Loading Problems:**
   ```vim
   :Lazy               " Check plugin status
   :Lazy sync          " Sync plugins
   :Lazy clean         " Clean unused plugins
   ```

## 📋 Requirements

### System Dependencies
- **Neovim:** >= 0.9.0
- **Git:** For plugin management
- **Node.js:** For LSP servers and tools
- **PHP:** For Laravel development
- **Composer:** For PHP dependencies

### Optional Dependencies
- **Docker & Docker Compose:** For containerized development
- **ripgrep:** For faster searching
- **fd:** For faster file finding
- **Python:** For Python development support

## 🎯 Laravel Development Workflow

1. **Start Development:**
   ```bash
   docker-compose up -d  # Start containers
   nvim                  # Open Neovim
   ```

2. **Run Tests:**
   - `<leader>tt` - Run nearest test
   - `<leader>ts` - View test summary
   - `<leader>tr` - Check test output

3. **Code Navigation:**
   - `<leader>ff` - Find files
   - `<leader>gd` - Go to definition
   - `<leader>ca` - Code actions

4. **Debugging:**
   - `<F5>` - Start debugging
   - `<leader>db` - Set breakpoints

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This configuration is open source and available under the [MIT License](LICENSE).

---

*Built with ❤️ for Laravel and Vue.js development*
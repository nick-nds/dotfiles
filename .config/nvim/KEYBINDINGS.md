# Neovim Keybindings Reference

Access this file with `<leader>hc` for quick reference during development.

## Leader Keys
- **Leader Key**: `<Space>`
- **Local Leader**: `,` (for .norg files and buffer-specific commands)

## Core Navigation & Operations

### Window & Tab Management
| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Navigate between windows |
| `<leader>e` | Quit current buffer |
| `<leader>q` | Quit all |
| `<leader>T` | Close active tab |
| `<leader>t` | View tabs |
| `<C-t>` | New tab |
| `<C-left/right>` | Move tab left/right |
| `<leader>b` | Switch to last buffer |

### Clipboard & Basic Operations
| Key | Action |
|-----|--------|
| `cp` | Copy to system clipboard |

## LSP & Code Intelligence

### Navigation & Actions
| Key | Action |
|-----|--------|
| `<leader>gd` | Go to definition |
| `<leader>gr` | Find references |
| `<leader>ca` | Code actions |
| `<leader>lf` | Format with LSP |
| `<leader>rn` | Rename symbol |
| `K` | Hover documentation |

### Diagnostics
| Key | Action |
|-----|--------|
| `[d` / `]d` | Navigate diagnostics |
| `<leader>gl` | Show line diagnostics |
| `<leader>ld` | List all diagnostics |
| `<leader>dv` | Toggle virtual text |

### LSP Resource Management
| Key | Action |
|-----|--------|
| `<leader>ls` | LSP status |
| `<leader>lr` | Restart heavy servers |
| `<leader>lk` | Stop non-essential |
| `<leader>le` | Emergency stop |

### Tailwind CSS Control
| Key | Action |
|-----|--------|
| `<leader>twt` | Toggle Tailwind LSP |
| `<leader>twp` | Tailwind performance mode |

## Testing Framework

### PHP/Laravel Testing
| Key | Action |
|-----|--------|
| `<leader>tt` | Run nearest test (Neotest) |
| `<leader>tf` | Run file tests (Neotest) |
| `<leader>ta` | Run all tests (Neotest) |
| `<leader>tu` | Run unit tests |
| `<leader>tF` | Run feature tests |
| `<leader>tr` | Show test results |
| `<leader>ts` | Toggle test summary |
| `<leader>to` | Toggle test output panel |

### JavaScript/Vue Testing
| Key | Action |
|-----|--------|
| `<leader>tjs` | Update test snapshots |
| `<leader>tu` | Open test UI |

## Note Taking & Documentation

### Obsidian Integration
| Key | Action |
|-----|--------|
| `<leader>on` | New Obsidian note |
| `<leader>oo` | Open in Obsidian app |
| `<leader>of` | Quick switch notes |
| `<leader>ob` | Show backlinks |
| `<leader>ot` | Search tags |
| `<leader>od` | Today's daily note |
| `<leader>oy` | Yesterday's daily note |
| `<leader>om` | Tomorrow's daily note |
| `<leader>os` | Search in vault |
| `<leader>ol` | Link to existing note |
| `<leader>oL` | Link to new note |
| `<leader>oe` | Insert template |
| `<leader>or` | Rename note |
| `<leader>ow` | Switch workspace |
| `<leader>op` | Paste image |
| `<leader>ch` | Toggle checkbox (in .md files) |

### Neorg Integration
| Key | Action |
|-----|--------|
| `<leader>nw` | Switch Neorg workspace |
| `<leader>ni` | Open Neorg index |
| `<leader>nr` | Return from Neorg |
| `<leader>nj` | Today's journal |
| `<leader>ny` | Yesterday's journal |
| `<leader>nt` | Tomorrow's journal |

### Neorg Todo Management (in .norg files)
| Key | Action |
|-----|--------|
| `,tt` | Toggle todo state |
| `,td` | Mark done |
| `,tu` | Mark undone |
| `,tc` | Mark cancelled |
| `,th` | Mark on hold |
| `,ti` | Mark important |
| `,tr` | Mark recurring |
| `,tp` | Mark pending |

### Task Management Integration
| Key | Action |
|-----|--------|
| `<leader>tC` | Create task from line |
| `<leader>tl` | List tasks |
| `<leader>tp` | List Neorg project tasks |
| `<leader>td` | Mark task done |
| `<leader>tm` | Modify task |
| `<leader>tq` | Quick task creation |
| `<leader>tP` | List tasks by project |
| `<leader>tn` | Add note to task |
| `<leader>ta` | View task annotations |
| `<leader>to` | Open task note file |

## Development Utilities

### Snippets
| Key | Action |
|-----|--------|
| `<leader>ss` | Reload snippets |

### Documentation Access
| Key | Action |
|-----|--------|
| `<leader>hc` | Open this keybindings reference |

## Commands Reference

### LSP Commands
- `:LspStatus` - Show active LSPs and memory usage
- `:LspRestart` - Restart heavy LSP servers
- `:LspStop` - Stop non-essential LSPs
- `:LspEmergencyStop` - Kill all LSP servers

### Tailwind Commands
- `:TailwindToggle` - Toggle on/off
- `:TailwindPerformanceMode` - Enable performance mode

### Testing Commands
- `:TestFile` - Run tests in current file
- `:TestNearest` - Run test nearest to cursor
- `:TestAll` - Run all project tests
- `:TestStatus` - Show testing environment status
- `:TestPrepareDB` - Prepare test database
- `:TestRefreshDB` - Refresh test database
- `:TestDebug` - Debug nearest test
- `:TestUI` - Open Vitest UI

### PHP Formatting Commands
- `:PintFormat` - Format current file with Laravel Pint
- `:PintFormatProject` - Format entire project with Laravel Pint

### Terminal Navigation (when tests fail)
| Key | Action |
|-----|--------|
| `<Esc>` | Exit insert mode in terminal |
| `j/k` | Navigate up/down |
| `<C-u>/<C-d>` | Page up/down |
| `gg/G` | Go to top/bottom |
| `q` | Close terminal |

## Performance Notes

- **LSP Memory Management**: Servers auto-restart at 500MB usage
- **Diagnostic Limiting**: Max 50 per buffer to prevent lag
- **Tailwind**: Start only when needed with `:TailwindToggle`
- **Testing Priority**: Artisan alias → Docker → System PHP

## Workflow Tips

1. **TDD Workflow**: Use `<leader>tt` for continuous test-driven development
2. **Performance Check**: Use `<leader>ls` if editor becomes sluggish
3. **Note Taking**: Use Obsidian for knowledge management, Neorg for project tasks
4. **Emergency**: Use `<leader>le` if LSP servers consume too much memory
# CLAUDE.md - Neovim Configuration Guide

## Commands
- No explicit build/lint commands (Neovim configuration)
- LSP formatting: `<leader>lf`
- Code actions: `<leader>ca`
- Diagnostics:
  - Show line diagnostics: `<leader>gl`
  - Navigate diagnostics: `[d` (previous) and `]d` (next)
  - List all diagnostics: `<leader>ld`
  - Toggle virtual text: `<leader>dv`
- Testing with Neotest:
  - Test file: `:lua require("neotest").run.run(vim.fn.expand("%"))`
  - Test at cursor: `:lua require("neotest").run.run()`
- Debug commands:
  - Start/continue: `<F5>`
  - Toggle breakpoint: `<leader>db`
  - Step over: `<F10>`, step into: `<F11>`, step out: `<F12>`
  - Toggle DAP UI: `<leader>dt`
- Snippets:
  - Navigate: `<Tab>` and `<S-Tab>`
  - Reload snippets: `<leader>ss`

## Code Style
- Indentation: 2 spaces (tabstop=2, shiftwidth=2)
- Max line length: 120 characters
- Neovim plugins configured in individual files under `lua/plugins/`
- Plugin structure: `return { repo, config = function() ... end }`
- Keybindings use `vim.keymap.set()` with descriptive names

## Technologies
- Plugin manager: lazy.nvim
- LSP: Mason for installation + null-ls for formatting/linting
- Languages: PHP/Laravel, Vue, JavaScript/TypeScript, Python, Bash
- Formatters: Laravel Pint (PHP), Prettier (JS/TS/Vue), Black (Python)
- Linters: ESLint, PHPStan, Flake8, Shellcheck
- Debugging: nvim-dap with DAP UI
- Snippets: LuaSnip with custom Laravel and Vue snippets

## Laravel Specific
- Pint formatter commands:
  - `<leader>pf` - Format current PHP file with Pint
  - `<leader>pa` - Format all PHP files in the project with Pint
  - `:PintCreateConfig` - Create a default pint.json configuration
  - `:PintAddFileHeader` - Add a file header to pint.json configuration

## Copilot
- Copilot is disabled by default (set `vim.g.copilot_enabled = true` to enable)
- Commands:
  - `<leader>ct` - Toggle Copilot enabled/disabled state (requires restart)
  - `<leader>cs` - Check current Copilot status
  - `:CopilotToggle` - Same as `<leader>ct`
  - `:CopilotStatus` - Same as `<leader>cs`
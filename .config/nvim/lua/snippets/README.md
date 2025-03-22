# Custom Snippets for Neovim

This directory contains custom snippets for Neovim using LuaSnip. The snippets are organized by language and can be easily extended.

## Available Snippet Sets

- **Laravel/PHP Snippets**: `laravel.lua`
- **Vue.js Snippets**: `vue.lua`

## Usage Instructions

### Basic Usage

1. Start typing a snippet prefix in insert mode
2. Press `<Tab>` to expand the snippet
3. Use `<Tab>` and `<S-Tab>` to navigate between placeholder fields
4. Fill in the placeholder values as needed

### Reloading Snippets

If you make changes to any snippet files, you can reload them without restarting Neovim by pressing:

```
<leader>ss
```

## Laravel Snippets

| Prefix      | Description                           |
|-------------|---------------------------------------|
| lcontroller | Create a resource controller          |
| lmodel      | Create a model with fillable attributes |
| lbelongsto  | Create belongsTo relationship method  |
| lhasmany    | Create hasMany relationship method    |
| lmigration  | Create a migration                    |
| lrequest    | Create a form request                 |
| lform       | Create a Blade form                   |
| lcomponent  | Create a Blade component              |
| lfactory    | Create a model factory                |
| lroutes     | Create a route group                  |

## Vue Snippets

| Prefix      | Description                           |
|-------------|---------------------------------------|
| v3setup     | Vue 3 component with script setup     |
| v3ts        | Vue 3 component with TypeScript       |
| v3comp      | Vue 3 component with Composition API  |
| v3compts    | Vue 3 Composition API with TypeScript |
| vref        | Create a ref                          |
| vcomputed   | Create a computed property            |
| vwatch      | Create a watch                        |
| vwatcheffect| Create a watchEffect                  |
| vonmounted  | Create onMounted lifecycle hook       |
| vlifecycle  | Create all lifecycle hooks            |
| vemit       | Create emit definition and function   |
| vfor        | Create v-for loop                     |
| vif         | Create v-if/v-else blocks             |

## Adding Your Own Snippets

1. Create a new file in the `snippets` directory (e.g., `python.lua`)
2. Follow the pattern in existing snippet files
3. Add your new snippet module to `init.lua`
4. Reload snippets with `<leader>ss`

Example of adding a new snippet file:

```lua
-- In snippets/init.lua
local python_snippets = require("snippets.python")
ls.add_snippets("python", python_snippets)
```
-- Formatting and Linting Configuration
-- null-ls sources and custom formatters

local M = {}

-- Tools to ensure via Mason
M.ensure_installed = { 
  "prettier", 
  "php-cs-fixer",
  "eslint", 
  "phpstan",
  "black",
  "isort", 
  "flake8",
  "shellcheck",
  "shfmt"
}

-- Custom Laravel Pint formatter
M.create_pint_formatter = function(null_ls)
  return {
    name = "laravel_pint",
    method = null_ls.methods.FORMATTING,
    filetypes = { "php" },
    generator = null_ls.generator({
      command = "pint",
      args = function(params)
        return {
          "--no-interaction",
          "--quiet",
          params.temp_path
        }
      end,
      to_temp_file = true,
      from_temp_file = true,
      format = "raw",
      check_exit_code = function(code)
        return code <= 1 -- 0 = success, 1 = fixed, >1 = error
      end,
      on_output = function(params, done)
        return done(params.output)
      end,
    }),
  }
end

-- Get available null-ls sources
M.get_sources = function(null_ls)
  local sources = {}
  
  -- Helper functions to check availability
  local has_formatter = function(name)
    return null_ls.builtins.formatting[name] ~= nil
  end
  
  local has_diagnostic = function(name)
    return null_ls.builtins.diagnostics[name] ~= nil
  end
  
  local has_action = function(name)
    return null_ls.builtins.code_actions[name] ~= nil
  end

  -- Formatters
  if has_formatter("prettier") then
    table.insert(sources, null_ls.builtins.formatting.prettier.with({
      prefer_local = "node_modules/.bin",
      filetypes = {
        "javascript", "javascriptreact", "typescript", "typescriptreact", 
        "vue", "css", "scss", "less", "html", "json", "yaml", 
        "markdown", "graphql"
      },
    }))
  end
  
  if has_formatter("phpcsfixer") then
    table.insert(sources, null_ls.builtins.formatting.phpcsfixer.with({
      prefer_local = "vendor/bin",
    }))
  end
  
  -- Add custom Pint formatter
  table.insert(sources, M.create_pint_formatter(null_ls))
  
  if has_formatter("black") then
    table.insert(sources, null_ls.builtins.formatting.black.with({
      extra_args = {"--fast"},
    }))
  end
  
  if has_formatter("isort") then
    table.insert(sources, null_ls.builtins.formatting.isort.with({
      args = {"--profile", "black", "-"},
    }))
  end
  
  if has_formatter("shfmt") then  
    table.insert(sources, null_ls.builtins.formatting.shfmt)
  end

  -- Diagnostics/Linters
  if has_diagnostic("eslint") then
    table.insert(sources, null_ls.builtins.diagnostics.eslint.with({
      prefer_local = "node_modules/.bin",
    }))
  end
  
  if has_diagnostic("phpstan") then
    table.insert(sources, null_ls.builtins.diagnostics.phpstan.with({
      prefer_local = "vendor/bin",
    }))
  end
  
  if has_diagnostic("flake8") then
    table.insert(sources, null_ls.builtins.diagnostics.flake8)
  end
  
  if has_diagnostic("shellcheck") then
    table.insert(sources, null_ls.builtins.diagnostics.shellcheck)
  end

  -- Code Actions
  if has_action("eslint") then
    table.insert(sources, null_ls.builtins.code_actions.eslint.with({
      prefer_local = "node_modules/.bin",
    }))
  end
  
  if has_action("shellcheck") then
    table.insert(sources, null_ls.builtins.code_actions.shellcheck)
  end

  return sources
end

return M
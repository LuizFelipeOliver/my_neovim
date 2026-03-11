local function get_files()
  local files = vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/config/lang", "*.lua", false, true)
  return vim.tbl_map(function(f) return vim.fn.fnamemodify(f, ":t:r") end, files)
end

vim.api.nvim_create_user_command("ILang", function(opts)
  local language = opts.args
  local ok, spec = pcall(require, "config.lang." .. language)

  if not ok then
    vim.notify("Linguagem não encontrada: " .. language, vim.log.levels.ERROR)
    return
  end

  vim.tbl_map(vim.cmd, spec.install or {})
  vim.notify("Instalando ambiente: " .. language, vim.log.levels.INFO)
end, {
  nargs = 1,
  complete = get_files,
})

vim.api.nvim_create_user_command("ULang", function(opts)
  local language = opts.args
  local ok, spec = pcall(require, "config.lang." .. language)

  if not ok then
    vim.notify("Linguagem não encontrada: " .. language, vim.log.levels.ERROR)
    return
  end

  vim.tbl_map(vim.cmd, spec.uninstall or {})
  vim.notify("Desinstalando ambiente: " .. language, vim.log.levels.INFO)
end, {
  nargs = 1,
  complete = get_files,
})

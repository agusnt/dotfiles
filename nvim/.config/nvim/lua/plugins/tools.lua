-- Small tools: surround, sessions, diagnostics list, tasks
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- pcall: a plugin that failed to install must not abort the rest of the config
-- surround: ys/ds/cs, persistence: sessions, trouble: diagnostics list, overseer: tasks
for _, name in ipairs({ "nvim-surround", "persistence", "trouble", "overseer" }) do
  local ok, mod = pcall(require, name)
  if ok then mod.setup({}) else vim.notify(name .. ': ' .. mod, vim.log.levels.WARN) end
end

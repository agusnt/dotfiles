-- Floating terminal toggle
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- One persistent terminal buffer shown in a centered floating window
local M = {}
local buf, win

-- Show the terminal, or hide it if it is already visible
function M.toggle()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_hide(win)
    win = nil
    return
  end
  if not (buf and vim.api.nvim_buf_is_valid(buf)) then
    buf = vim.api.nvim_create_buf(false, true)
  end
  local w, h = math.floor(vim.o.columns * 0.85), math.floor(vim.o.lines * 0.8)
  win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor', style = 'minimal', border = 'rounded',
    width = w, height = h,
    col = math.floor((vim.o.columns - w) / 2), row = math.floor((vim.o.lines - h) / 2) - 1,
  })
  if vim.bo[buf].buftype ~= 'terminal' then vim.fn.jobstart(vim.o.shell, { term = true }) end
  vim.cmd.startinsert()
end

return M

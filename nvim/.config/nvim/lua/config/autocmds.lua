-- General autocommands
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- All autocommands share one augroup so reloading this file does not duplicate them
local group = vim.api.nvim_create_augroup('UserAutocmds', { clear = true })
local function au(event, opts) opts.group = group; vim.api.nvim_create_autocmd(event, opts) end

au('TextYankPost', { callback = function() vim.hl.on_yank() end }) -- Flash the yanked text

au('BufReadPost', { -- Back to the last cursor position
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

au('BufWritePre', { -- Trim trailing whitespace (markdown uses it for line breaks)
  callback = function(ev)
    if vim.bo[ev.buf].filetype == 'markdown' or not vim.bo[ev.buf].modifiable then return end
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

-- Reload files changed outside nvim (git checkout, formatters, other programs)
vim.o.autoread = true
au({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
  callback = function() if vim.fn.getcmdwintype() == '' then vim.cmd.checktime() end end,
})

au('VimResized', { callback = function() vim.cmd.wincmd('=') end }) -- Keep splits even

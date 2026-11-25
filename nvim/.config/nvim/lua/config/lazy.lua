-- Deferred loading: heavy plugin setups run right after the first draw (or earlier,
-- on the events/commands that need them) so the editor appears sooner.
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local M = {}

local queue, done = {}, {}

-- Run `fn` once, named `name`; a later call with the same name is ignored
local function run(name, fn)
  if done[name] then return end
  done[name] = true
  local ok, err = pcall(fn)
  if not ok then vim.notify(name .. ': ' .. tostring(err), vim.log.levels.WARN) end
end

-- Register `fn` to run after the first draw; `opts.events` also runs it earlier, on
-- the first of those events (e.g. InsertEnter for completion)
function M.defer(name, fn, opts)
  queue[#queue + 1] = { name = name, fn = fn }
  local events = opts and opts.events
  if events then
    vim.api.nvim_create_autocmd(events, { once = true, callback = function() run(name, fn) end })
  end
end

-- Run everything queued, one task per event-loop turn so the UI stays responsive
local function flush()
  local i = 0
  local function step()
    i = i + 1
    local task = queue[i]
    if not task then return end
    run(task.name, task.fn)
    vim.schedule(step)
  end
  step()
end

-- No UI attached (headless, scripts): there is no draw to wait for
if #vim.api.nvim_list_uis() == 0 then
  vim.api.nvim_create_autocmd('VimEnter', { once = true, callback = function() vim.schedule(flush) end })
else
  vim.api.nvim_create_autocmd('UIEnter', { once = true, callback = function() vim.defer_fn(flush, 10) end })
end

-- Define `name` as a command that loads `fn` first, then runs itself again
function M.command(name, fn)
  vim.api.nvim_create_user_command(name, function(o)
    pcall(vim.api.nvim_del_user_command, name) -- Drop the stub; the plugin defines the real one
    run(name, fn)
    vim.cmd({ cmd = name, args = o.fargs, bang = o.bang })
  end, { nargs = '*', bang = true })
end

return M

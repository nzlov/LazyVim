-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local o = vim.o
o.background = "light"
o.wrap = true -- Disable line wrap
o.shiftwidth = 2
o.tabstop = 2

local g = vim.g
g.transparency = true

-- if string.find(vim.loop.os_uname().release, "microsoft") then
--   g.clipboard = {
--     name = "WslClipboard",
--     copy = {
--       ["+"] = "clip.exe",
--       ["*"] = "clip.exe",
--     },
--     paste = {
--       ["+"] = 'powershell.exe -NoProfile -NonInteractive -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
--       ["*"] = 'powershell.exe -NoProfile -NonInteractive -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
--     },
--     cache_enabled = false,
--   }
--   -- vim.g.clipboard = {
--   --   name = "wl-clipboard (wsl)",
--   --   copy = {
--   --     ["+"] = "wl-copy --foreground --type text/plain",
--   --     ["*"] = "wl-copy --foreground --primary --type text/plain",
--   --   },
--   --   paste = {
--   --     ["+"] = function()
--   --       return vim.fn.systemlist('wl-paste --no-newline|sed -e "s/\r$//"', { "" }, 1) -- '1' keeps empty lines
--   --     end,
--   --     ["*"] = function()
--   --       return vim.fn.systemlist('wl-paste --primary --no-newline|sed -e "s/\r$//"', { "" }, 1)
--   --     end,
--   --   },
--   --   cache_enabled = true,
--   -- }
-- end

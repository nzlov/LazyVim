-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set

map("i", "<c-h>", "<Left>", { desc = "Move cursor left", remap = true })
map("i", "<c-j>", "<Down>", { desc = "Move cursor down", remap = true })
map("i", "<c-k>", "<Up>", { desc = "Move cursor up", remap = true })
map("i", "<c-l>", "<Right>", { desc = "Move cursor right", remap = true })

require("config.remote_clipboard").setup()
-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = true
vim.opt.wrap = true -- Enable line wrap
vim.opt.formatoptions:remove({ "o" }) -- Empty line after comment
vim.opt.spell = false -- Turn off built-in spell checker

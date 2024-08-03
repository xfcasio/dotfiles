require "nvchad.mappings"

-- add yours here
require("nvterm").setup()

local map = vim.keymap.set

local terminal = require("nvterm.terminal")

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map({'n', 't'}, '<A-k>', function ()
  require("nvchad.term").toggle { pos = "sp", size = 0.7 }
end)

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

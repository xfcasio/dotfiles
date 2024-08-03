local present, nvimtree = pcall(require, "nvim-tree")

if not present then
  return
end

local options = {
  size = 5;
}

options = require("core.utils").load_override(options, "kyazdani42/nvim-tree.lua")
nvimtree.setup(options)

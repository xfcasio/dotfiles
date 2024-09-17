-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "gruvchad",

  statusline = {
    theme = 'minimal',
    separator_style = 'block'
  },

  hl_override = {
    Comment = { italic = true },
    Keyword = { italic = true },
    Statement = { italic = true },
    Variable = { italic = true },
    Type = { italic = true },
    Include = { italic = true },
    TSKeyword = { italic = true },
    TSDefine = { italic = true },
    TSKeyword = { italic = true },
    TSMethod = { italic = true },
    TSVariable = { italic = true },
    SpecialComment = { italic = true },

    NvimTreeNormal = { bg = 'none' },
    NvimTreeNormalNC = { bg = 'none' },

    --["@comment"] = { italic = true },
    Normal = {
      bg = "none",
      fg = "#a9a9a9",
    },
  },
}

return M

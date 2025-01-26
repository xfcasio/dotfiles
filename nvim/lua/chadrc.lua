-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.ui = {
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
  }
}

M.base46 = {
  theme = 'rxyhn',

  hl_override = {
    Normal = {
      bg = "none",
      fg = "#A9A9A9", 
    },

    NvimTreeNormal = { bg = 'none' },
    NvimTreeNormalNC = { bg = 'none' },
  },
}

return M

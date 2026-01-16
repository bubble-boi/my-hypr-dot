-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "plugins" },
})

-- treesitter
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
    vim.bo[args.buf].syntax = "on"
    --vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    --vim.wo.foldmethod = "expr"
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})


-- 
vim.opt.wrap = false
vim.opt.number = true
vim.opt.virtualedit = "onemore"

-- transparent bg
vim.api.nvim_set_hl(0, "Normal",      { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC",    { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })

-- showmode off (global)
vim.opt.showmode = false

-- nvim <dir> で起動したらファイラを開く
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)
    if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
      vim.cmd("Ex")
    end
  end,
})

-- `-` は「ファイラをトグル」(netrw内は閉じる / それ以外は縦で開く)
vim.keymap.set("n", "-", function()
  if vim.bo.filetype == "netrw" then
    vim.cmd("close")
  else
    vim.cmd("Vex")
  end
end, { noremap = true, silent = true })

-- netrw 設定
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 3
vim.g.netrw_winsize = 25

-- wrap over line edges
vim.opt.whichwrap = "b,s,h,l,<,>"
vim.opt.clipboard = "unnamedplus"

-- 矢印行移動
vim.keymap.set("i", "<Left>",  "<C-o>h", { silent = true })
vim.keymap.set("i", "<Right>", "<C-o>l", { silent = true })

-- Ctrl+S -> :w!
vim.keymap.set("i", "<C-s>", "<Esc>:w!<CR>i", { noremap = true, silent = true })
vim.keymap.set("n", "<C-s>", ":w!<CR>", { noremap = true, silent = true })

-- Ctrl+C -> :q!
vim.keymap.set("i", "<C-c>", "<Esc>:q!<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-c>", ":q!<CR>", { noremap = true, silent = true })


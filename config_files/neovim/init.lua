local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  -- LSP Configuration & Plugins
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").pyright.setup({})
    end,
  },
  -- Treesitter for better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "python" },
        highlight = { enable = true },
      }
    end,
  },
  -- Ruff integration
  {
    "mfussenegger/nvim-lint",
    config = function()
      require('lint').linters_by_ft = {
        python = {'ruff'}
      }
    end,
  },
})

-- Key mappings for LSP actions
vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })

-- Autoformat on save
vim.cmd("autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync(nil, 100)")

-- Enable line numbers
vim.opt.number = true

vim.opt.textwidth = 80
vim.opt.wrap = true
vim.opt.colorcolumn = "80"
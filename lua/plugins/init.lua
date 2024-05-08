return {

  { "ellisonleao/gruvbox.nvim" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },

  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    config = function()
      require("auto-dark-mode").setup({
        update_interval = 1000,
        set_dark_mode = function()
          vim.g.transparency = false
          vim.o.background = "dark"
        end,
        set_light_mode = function()
          vim.g.transparency = true
          vim.o.background = "light"
        end,
      })
    end,
  },

  {
    "mbbill/undotree",
    cmd = { "UndotreeToggle" },
    keys = {
      {
        "<leader>U",
        function()
          vim.cmd.UndotreeToggle()
        end,
        desc = "UndotreeToggle",
      },
    },
  },
  { "mg979/vim-visual-multi" },
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    lazy = true,
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
}

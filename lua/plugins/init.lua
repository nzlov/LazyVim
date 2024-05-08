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
      local replace_word = function(old, new)
        local chadrc = vim.fn.stdpath("config") .. "/lua/config/options.lua"
        local file = io.open(chadrc, "r")
        local added_pattern = string.gsub(old, "-", "%%-") -- add % before - if exists
        local new_content = file:read("*all"):gsub(added_pattern, new)

        file = io.open(chadrc, "w")
        file:write(new_content)
        file:close()
      end

      require("auto-dark-mode").setup({
        update_interval = 1000,
        set_dark_mode = function()
          replace_word('o.background = "light"', 'o.background = "dark"')
          vim.o.background = "dark"
        end,
        set_light_mode = function()
          replace_word('o.background = "dark"', 'o.background = "light"')
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

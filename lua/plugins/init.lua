local _float_console = function()
  require("dapui").float_element("console", {
    enter = true,
    title = "console",
    position = "center",
    height = math.floor(vim.o.lines * 0.9),
    width = math.floor(vim.o.columns * 0.8),
  })
end

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
    "nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
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
  {
    "javiorfo/nvim-wildcat",
    lazy = true,
    ft = "java",
    cmd = { "WildcatRun", "WildcatUp", "WildcatInfo" },
    dependencies = { "javiorfo/nvim-popcorn" },
    opts = {
      -- Not necessary. Only if you want to change the setup
      -- The following are the default values

      console_size = 15,
      tomcat = {
        home = "/home/nzlov/workspaces/apache-tomcat-9.0.97",
        app_base = "webapps",
        default = true,
      },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    keys = {
      {
        "<leader>dd",
        _float_console,
        desc = "Dap UI console",
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping = cmp.mapping.preset.insert({
        ["<C-o>"] = cmp.mapping.complete(),
        ["<CR>"] = LazyVim.cmp.confirm({ select = true }),
      })
    end,
  },
}

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
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        _float_console()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    opts = function(_, opts)
      local cmp = require("cmp")
      local auto_select = true
      opts.mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-o>"] = cmp.mapping.complete(),
        ["<CR>"] = LazyVim.cmp.confirm({ select = auto_select }),
        ["<C-y>"] = LazyVim.cmp.confirm({ select = true }),
        ["<S-CR>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<C-CR>"] = function(fallback)
          cmp.abort()
          fallback()
        end,
        ["<tab>"] = function(fallback)
          return LazyVim.cmp.map({ "snippet_forward", "ai_accept" }, fallback)()
        end,
      })
    end,
  },
}

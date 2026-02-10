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
  --{ "mg979/vim-visual-multi" },
  -- {
  --   "iamcco/markdown-preview.nvim",
  --   ft = "markdown",
  --   lazy = true,
  --   run = function()
  --     vim.fn["mkdp#util#install"]()
  --   end,
  -- },
  -- {
  --   "javiorfo/nvim-wildcat",
  --   lazy = false,
  --   cmd = { "WildcatRun", "WildcatUp", "WildcatInfo" },
  --   dependencies = { "javiorfo/nvim-popcorn" },
  --   opts = {
  --     -- Not necessary. Only if you want to change the setup
  --     -- The following are the default values
  --
  --     console_size = 15,
  --     tomcat = {
  --       home = "/home/nzlov/workspaces/apache-tomcat-9.0.97",
  --       app_base = "webapps",
  --       default = true,
  --     },
  --   },
  -- },
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

  -- {
  --   "TabbyML/vim-tabby",
  --   lazy = false,
  --   dependencies = {
  --     "neovim/nvim-lspconfig",
  --   },
  --   init = function()
  --     vim.g.tabby_agent_start_command = { "npx", "tabby-agent", "--stdio" }
  --     vim.g.tabby_inline_completion_trigger = "auto"
  --   end,
  -- },
  {
    "folke/snacks.nvim",
    opts = {
      terminal = {
        win = {
          position = "float",
        },
      },
    },
  },
}

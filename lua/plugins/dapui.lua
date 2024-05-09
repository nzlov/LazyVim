local _float_console = function()
  require("dapui").float_element("console", {
    position = "center",
    height = math.floor(vim.o.lines * 0.9),
    width = math.floor(vim.o.columns * 0.8),
  })
end
return {
  {
    "rcarriga/nvim-dap-ui",
    keys = {
      { "<leader>dd", _float_console, desc = "Float console" },
    },
    config = function(_, opts)
      -- setup dap config by VsCode launch.json file
      -- require("dap.ext.vscode").load_launchjs()
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
}

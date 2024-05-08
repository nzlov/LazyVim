function _float_console()
  require("dapui").float_element(
    "console",
    { position = "center", height = math.floor(vim.o.lines * 0.9), width = math.floor(vim.o.columns * 0.8) }
  )
end
return {
  {
    "rcarriga/nvim-dap-ui",
    keys = {
      { "<leader>dd", _float_console },
    },
  },
}

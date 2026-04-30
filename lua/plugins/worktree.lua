return {
  {
    "Juksuu/worktrees.nvim",
    opts = {
      worktree_path = "~/.local/share/nvim/worktrees",
    },
    keys = {
      {
        "<leader>gwc",
        function()
          Snacks.picker.worktrees_new()
        end,
        desc = "Create worktree",
      },
      {
        "<leader>gws",
        function()
          Snacks.picker.worktrees()
        end,
        desc = "Select worktree",
      },
      {
        "<leader>gwr",
        function()
          Snacks.picker.worktrees_remove()
        end,
        desc = "Remove worktree",
      },
    },
  },
}

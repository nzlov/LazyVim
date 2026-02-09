return {
  {
    "sudo-tee/opencode.nvim",
    config = function()
      require("opencode").setup({
        preferred_picker = "snacks",
        default_global_keymaps = false,
        keymap_prefix = "<leader>a",
        keymap = {
          editor = {
            ["<leader>aa"] = { "toggle", desc = "Toogle opencode" },
            ["<leader>ai"] = { "open_input", desc = "Opens and focuses on input window on insert mode" },
            ["<leader>aI"] = {
              "open_input_new_session",
              desc = "Opens and focuses on input window on insert mode. Creates a new session",
            },
            ["<leader>ao"] = { "open_output", desc = "Opens and focuses on output window" },
            ["<leader>at"] = { "toggle_focus", desc = "Toggle focus between opencode and last window" },
            ["<leader>aT"] = { "timeline", desc = "Display timeline picker to navigate/undo/redo/fork messages" },
            ["<leader>aq"] = { "close", desc = "Close UI windows" },
            ["<leader>as"] = { "select_session", desc = "Select and load a opencode session" },
            ["<leader>aR"] = { "rename_session", desc = "Rename current session" },
            ["<leader>ap"] = { "configure_provider", desc = "Quick provider and model switch from predefined list" },
            ["<leader>aV"] = { "configure_variant", desc = "Switch model variant for the current model" },
            ["<leader>az"] = { "toggle_zoom", desc = "Zoom in/out on the Opencode windows" },
            ["<leader>av"] = { "paste_image", desc = "Paste image from clipboard into current session" },
            ["<leader>ad"] = {
              "diff_open",
              desc = "Opens a diff tab of a modified file since the last opencode prompt",
            },
            ["<leader>a]"] = { "diff_next", desc = "Navigate to next file diff" },
            ["<leader>a["] = { "diff_prev", desc = "Navigate to previous file diff" },
            ["<leader>ac"] = { "diff_close", desc = "Close diff view tab and return to normal editing" },
            ["<leader>ara"] = {
              "diff_revert_all_last_prompt",
              desc = "Revert all file changes since the last opencode prompt",
            },
            ["<leader>art"] = {
              "diff_revert_this_last_prompt",
              desc = "Revert current file changes since the last opencode prompt",
            },
            ["<leader>arA"] = { "diff_revert_all", desc = "Revert all file changes since the last opencode session" },
            ["<leader>arT"] = {
              "diff_revert_this",
              desc = "Revert current file changes since the last opencode session",
            },
            ["<leader>arr"] = { "diff_restore_snapshot_file", desc = "Restore a file to a restore point" },
            ["<leader>arR"] = { "diff_restore_snapshot_all", desc = "Restore all files to a restore point" },
            ["<leader>ax"] = { "swap_position", desc = "Swap Opencode pane left/right" },
            ["<leader>att"] = { "toggle_tool_output", desc = "Toggle tools output (diffs, cmd output, etc.)" },
            ["<leader>atr"] = { "toggle_reasoning_output", desc = "Toggle reasoning output (thinking steps)" },
            ["<leader>a/"] = {
              "quick_chat",
              mode = { "n", "x" },
              desc = "Open quick chat input with selection context in visual mode or current line context in normal mode",
            },
          },
          input_window = {
            ["<S-cr>"] = { "submit_input_prompt", mode = { "n", "i" } }, -- Submit prompt (normal mode and insert mode)
            ["<esc>"] = false,
            ["<C-c>"] = { "cancel" }, -- Cancel opencode request while it is running
            ["~"] = { "mention_file", mode = "i" }, -- Pick a file and add to context. See File Mentions section
            ["@"] = { "mention", mode = "i" }, -- Insert mention (file/agent)
            ["/"] = { "slash_commands", mode = "i" }, -- Pick a command to run in the input window
            ["#"] = { "context_items", mode = "i" }, -- Manage context items (current file, selection, diagnostics, mentioned files)
            ["<M-v>"] = { "paste_image", mode = "i" }, -- Paste image from clipboard as attachment
            ["<C-i>"] = { "focus_input", mode = { "n", "i" } }, -- Focus on input window and enter insert mode at the end of the input from the output window
            ["<tab>"] = { "toggle_pane", mode = { "n", "i" } }, -- Toggle between input and output panes
            ["<up>"] = { "prev_prompt_history", mode = { "n", "i" } }, -- Navigate to previous prompt in history
            ["<down>"] = { "next_prompt_history", mode = { "n", "i" } }, -- Navigate to next prompt in history
            ["<M-m>"] = { "switch_mode" }, -- Switch between modes (build/plan)
            ["<M-r>"] = { "cycle_variant", mode = { "n", "i" } }, -- Cycle through available model variants
          },
          output_window = {
            ["<esc>"] = false,
            ["<C-c>"] = { "cancel" }, -- Cancel opencode request while it is running
            ["]]"] = { "next_message" }, -- Navigate to next message in the conversation
            ["[["] = { "prev_message" }, -- Navigate to previous message in the conversation
            ["<tab>"] = { "toggle_pane", mode = { "n", "i" } }, -- Toggle between input and output panes
            ["i"] = { "focus_input", "n" }, -- Focus on input window and enter insert mode at the end of the input from the output window
            ["<M-r>"] = { "cycle_variant", mode = { "n" } }, -- Cycle through available model variants
            ["<leader>oS"] = { "select_child_session" }, -- Select and load a child session
            ["<leader>oD"] = { "debug_message" }, -- Open raw message in new buffer for debugging
            ["<leader>oO"] = { "debug_output" }, -- Open raw output in new buffer for debugging
            ["<leader>ods"] = { "debug_session" }, -- Open raw session in new buffer for debugging
          },
          session_picker = {
            rename_session = { "<C-r>" }, -- Rename selected session in the session picker
            delete_session = { "<C-d>" }, -- Delete selected session in the session picker
            new_session = { "<C-s>" }, -- Create and switch to a new session in the session picker
          },
          timeline_picker = {
            undo = { "<C-u>", mode = { "i", "n" } }, -- Undo to selected message in timeline picker
            fork = { "<C-f>", mode = { "i", "n" } }, -- Fork from selected message in timeline picker
          },
          history_picker = {
            delete_entry = { "<C-d>", mode = { "i", "n" } }, -- Delete selected entry in the history picker
            clear_all = { "<C-X>", mode = { "i", "n" } }, -- Clear all entries in the history picker
          },
          model_picker = {
            toggle_favorite = { "<C-f>", mode = { "i", "n" } },
          },
          mcp_picker = {
            toggle_connection = { "<C-t>", mode = { "i", "n" } }, -- Toggle MCP server connection in the MCP picker
          },
        },
      })
    end,
    dependencies = {
      "saghen/blink.cmp",
      -- 'hrsh7th/nvim-cmp',
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          anti_conceal = { enabled = false },
          file_types = {
            "markdown",
            "Avante",
            "copilot-chat",
            "opencode_output",
            "norg",
            "rmd",
            "org",
            "codecompanion",
          },
        },
        ft = { "markdown", "Avante", "copilot-chat", "opencode_output", "norg", "rmd", "org", "codecompanion" },
      },
      -- Optional, for file mentions picker, pick only one
      {
        "folke/snacks.nvim",
        opts = {
          picker = {
            actions = {
              opencode_send = function(picker)
                local selected = picker:selected({ fallback = true })
                if selected and #selected > 0 then
                  local files = {}
                  for _, item in ipairs(selected) do
                    if item.file then
                      table.insert(files, item.file)
                    end
                  end
                  picker:close()

                  require("opencode.core").open({
                    new_session = false,
                    focus = "input",
                    start_insert = true,
                  })

                  local context = require("opencode.context")
                  for _, file in ipairs(files) do
                    context.add_file(file)
                  end
                end
              end,
            },
            win = {
              input = {
                keys = {
                  -- Use <localleader>o or any preferred key to send files to opencode
                  ["<localleader>o"] = { "opencode_send", mode = { "n", "i" } },
                },
              },
            },
          },
        },
      },
      -- 'nvim-telescope/telescope.nvim',
      -- 'ibhagwan/fzf-lua',
      -- 'nvim_mini/mini.nvim',
    },
  },
}

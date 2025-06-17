return {
  {
    "saghen/blink.cmp",
    --optional = true,
    opts = {
      completion = {
        menu = {
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "source_name" },
            },
            treesitter = { "lsp" },
          },
        },
      },

      sources = {
        default = { "avante_commands", "avante_mentions", "avante_files" },
        compat = {
          "avante_commands",
          "avante_mentions",
          "avante_files",
        },
        -- LSP score_offset is typically 60
        providers = {
          avante_commands = {
            name = "avante_commands",
            module = "blink.compat.source",
            score_offset = 90,
            opts = {},
          },
          avante_files = {
            name = "avante_files",
            module = "blink.compat.source",
            score_offset = 100,
            opts = {},
          },
          avante_mentions = {
            name = "avante_mentions",
            module = "blink.compat.source",
            score_offset = 1000,
            opts = {},
          },
        },
      },

      keymap = {
        preset = "enter",
        ["<C-y>"] = { "select_and_accept" },
        ["<C-o>"] = { "show" },
        ["<Tab>"] = {
          LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
          "fallback",
        },
      },
    },
    dependencies = { "saghen/blink.compat" },
  },
  {
    --dir = "~/workspaces/nvim/avante.nvim",
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      debug = false,
      provider = "deepseek",
      auto_suggestions_provider = "code",
      cursor_applying_provider = "siliconflow",
      behaviour = {
        auto_focus_sidebar = true,
        auto_suggestions = false, -- Experimental stage
        auto_suggestions_respect_ignore = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = true,
        jump_result_buffer_on_finish = false,
        support_paste_from_clipboard = false,
        minimize_diff = true,
        enable_token_counting = true,
        enable_cursor_planning_mode = false,
        enable_claude_text_editor_tool_mode = false,
        use_cwd_as_project_root = false,
      },
      web_search_engine = {
        -- disable_tools = true,
      },
      providers = {
        mercury = {
          __inherited_from = "openai",
          api_key_name = "",
          endpoint = "http://localhost:8080",
          model = "lambda.mercury-coder-small",
        },
        code = {
          __inherited_from = "openai",
          api_key_name = "",
          endpoint = "http://localhost:11434/v1",
          model = "qwen3:8b",
        },
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com",
          model = "deepseek-reasoner",
          extra_request_body = {
            temperature = 0,
            max_completion_tokens = 8192,
          },
        },
        siliconflow = {
          __inherited_from = "openai",
          api_key_name = "SILICONFLOW_API_KEY",
          endpoint = "https://api.siliconflow.cn/v1",
          model = "deepseek-ai/DeepSeek-V3",
        },
        gpustack = {
          __inherited_from = "openai",
          api_key_name = "GPUSTACK_API_KEY",
          endpoint = "http://100.64.0.1:9180/v1",
          model = "qwen2.5",
        },
      },
      -- provider = "openai",
      -- openai = {
      --   endpoint = "http://100.64.0.1:9180/v1",
      --   model = "deepseek-r1-ollama", -- your desired model (or use gpt-4o, etc.)
      --   timeout = 30000, -- timeout in milliseconds
      --   temperature = 0, -- adjust if needed
      --   max_tokens = 4096,
      --   -- reasoning_effort = "high" -- only supported for reasoning models (o1, etc.)
      -- },
      rag_service = {
        enabled = false, -- Enables the rag service, requires OPENAI_API_KEY to be set
        provider = "ollama",
        endpoint = "http://172.17.0.1:11434",
        llm_model = "deepseek-r1",
        embed_model = "EntropyYue/jina-embeddings-v2-base-zh",
      },
      system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        return (hub and hub:get_active_servers_prompt() or "") .. "\n使用中文回答一切问题"
      end,
      disabled_tools = {
        "list_files",
        "search_files",
        "read_file",
        "create_file",
        "rename_file",
        "delete_file",
        "create_dir",
        "rename_dir",
        "delete_dir",
        "bash",
      },
      custom_tools = function()
        return {
          require("mcphub.extensions.avante").mcp_tool(),
          {
            name = "run_go_tests", -- Unique name for the tool
            description = "Run Go unit tests and return results", -- Description shown to AI
            command = "go test -v ./...", -- Shell command to execute
            param = { -- Input parameters (optional)
              type = "table",
              fields = {
                {
                  name = "target",
                  description = "Package or directory to test (e.g. './pkg/...' or './internal/pkg')",
                  type = "string",
                  optional = true,
                },
              },
            },
            returns = { -- Expected return values
              {
                name = "result",
                description = "Result of the fetch",
                type = "string",
              },
              {
                name = "error",
                description = "Error message if the fetch was not successful",
                type = "string",
                optional = true,
              },
            },
            func = function(params, on_log, on_complete) -- Custom function to execute
              local target = params.target or "./..."
              return vim.fn.system(string.format("go test -v %s", target))
            end,
          },
        }
      end,
      --- @alias FileSelectorProvider "native" | "fzf" | "mini.pick" | "snacks" | "telescope" | string
      file_selector = {
        provider = "fzf", -- Avoid native provider issues
        provider_opts = {},
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
      {
        "ravitemer/mcphub.nvim",
        build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
        config = function()
          math.randomseed()
          local cfg = function()
            local cwd_config = vim.fn.getcwd() .. "/mcpservers.json"
            if vim.fn.filereadable(cwd_config) == 1 then
              return cwd_config
            else
              return vim.fn.expand("~/mcpservers.json")
            end
          end

          require("mcphub").setup({
            -- Required options
            --port = 30000, -- Port for MCP Hub server
            port = math.random(50000, 50100), -- Port for MCP Hub server

            config = cfg(), -- Prioritize config in current directory, fall back to home
            shutdown_delay = 60 * 10 * 000, -- Delay in ms before shutting down the server when last instance closes (default: 10 minutes)
            use_bundled_binary = false, -- Use local `mcp-hub` binary (set this to true when using build = "bundled_build.lua")
            mcp_request_timeout = 60000, --Max time allowed for a MCP tool or resource to execute in milliseconds, set longer for long running tasks

            ---Chat-plugin related options-----------------
            auto_approve = false, -- Auto approve mcp tool calls
            auto_toggle_mcp_servers = true, -- Let LLMs start and stop MCP servers automatically
            extensions = {
              avante = {
                make_slash_commands = true, -- make /slash commands from MCP server prompts
              },
            },

            -- Optional options
            on_ready = function(hub)
              -- Called when hub is ready
            end,
            on_error = function(err)
              -- Called on errors
            end,
            shutdown_delay = 0, -- Wait 0ms before shutting down server after last client exits
            log = {
              level = vim.log.levels.WARN,
              to_file = false,
              file_path = nil,
              prefix = "MCPHub",
            },
          })
        end,
      },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>a", group = "ai" },
      },
    },
  },
}

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
      mode = "agentic", -- "legacy",
      provider = "deepseek",
      auto_suggestions_provider = "qwen3code",
      cursor_applying_provider = "qwen3code",
      rules = {
        project_dir = ".avante",
        global_dir = "$HOME/.config/nvim/rules/",
      },
      behaviour = {
        auto_focus_sidebar = true,
        auto_suggestions = false, -- Experimental stage
        auto_suggestions_respect_ignore = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        jump_result_buffer_on_finish = false,
        support_paste_from_clipboard = false,
        minimize_diff = true,
        enable_token_counting = true,
        use_cwd_as_project_root = false,
        auto_focus_on_diff_view = false,
        ---@type boolean | string[] -- true: auto-approve all tools, false: normal prompts, string[]: auto-approve specific tools by name
        auto_approve_tool_permissions = true, -- Default: auto-approve all tools (no prompts)
        auto_check_diagnostics = true,
        enable_fastapply = false,
        include_generated_by_commit_line = false, -- Controls if 'Generated-by: <provider/model>' line is added to git commit message
        auto_add_current_file = true, -- Whether to automatically add the current file when opening a new chat
        --- popup is the original yes,all,no in a floating window
        --- inline_buttons is the new inline buttons in the sidebar
        ---@type "popup" | "inline_buttons"
        confirmation_ui_style = "inline_buttons",
        --- Whether to automatically open files and navigate to lines when ACP agent makes edits
        ---@type boolean
        acp_follow_agent_locations = true,
      },
      web_search_engine = {
        -- disable_tools = true,
      },
      providers = {
        qwen3code = {
          __inherited_from = "openai",
          api_key_name = "",
          endpoint = "http://localhost:11434/v1",
          model = "qwen3-coder:latest",
        },
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com",
          model = "deepseek-chat",
          extra_request_body = {
            temperature = 0.7,
            max_completion_tokens = 8192,
          },
        },
        minimax = {
          __inherited_from = "openai",
          api_key_name = "MINIMAX_API_KEY",
          endpoint = "https://api.minimaxi.com/v1",
          model = "MiniMax-M2",
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
      rag_service = { -- RAG Service configuration
        enabled = false, -- Enables the RAG service
        host_mount = os.getenv("HOME"), -- Host mount path for the rag service (Docker will mount this path)
        runner = "docker", -- Runner for the RAG service (can use docker or nix)
        llm = { -- Language Model (LLM) configuration for RAG service
          provider = "ollama", -- LLM provider
          api_key = "", -- Environment variable name for the embedding API key
          endpoint = "http://172.17.0.1:11434",
          model = "qwen3-coder:latest", -- LLM model name
          extra = nil, -- Additional configuration options for LLM
        },
        embed = { -- Embedding model configuration for RAG service
          provider = "ollama", -- Embedding provider
          endpoint = "http://172.17.0.1:11434",
          api_key = "", -- Environment variable name for the embedding API key
          embed_model = "EntropyYue/jina-embeddings-v2-base-zh",
          extra = nil, -- Additional configuration options for the embedding model
        },
        docker_extra_args = "", -- Extra arguments to pass to the docker command
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
            verbose = false,
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
          require("mcphub").setup({
            --- `mcp-hub` binary related options-------------------
            config = vim.fn.expand("~/mcpservers.json"), -- Absolute path to MCP Servers config file (will create if not exists)
            port = 37373, -- The port `mcp-hub` server listens to
            shutdown_delay = 5 * 60 * 000, -- Delay in ms before shutting down the server when last instance closes (default: 5 minutes)
            use_bundled_binary = false, -- Use local `mcp-hub` binary (set this to true when using build = "bundled_build.lua")
            mcp_request_timeout = 60000, --Max time allowed for a MCP tool or resource to execute in milliseconds, set longer for long running tasks
            global_env = {}, -- Global environment variables available to all MCP servers (can be a table or a function returning a table)
            workspace = {
              enabled = true, -- Enable project-local configuration files
              look_for = { ".mcphub/servers.json", ".vscode/mcp.json", ".cursor/mcp.json" }, -- Files to look for when detecting project boundaries (VS Code format supported)
              reload_on_dir_changed = true, -- Automatically switch hubs on DirChanged event
              port_range = { min = 40000, max = 41000 }, -- Port range for generating unique workspace ports
              get_port = nil, -- Optional function returning custom port number. Called when generating ports to allow custom port assignment logic
            },

            ---Chat-plugin related options-----------------
            auto_approve = false, -- Auto approve mcp tool calls
            auto_toggle_mcp_servers = true, -- Let LLMs start and stop MCP servers automatically
            extensions = {
              avante = {
                make_slash_commands = true, -- make /slash commands from MCP server prompts
              },
            },

            --- Plugin specific options-------------------
            native_servers = {}, -- add your custom lua native servers here
            builtin_tools = {
              edit_file = {
                parser = {
                  track_issues = true,
                  extract_inline_content = true,
                },
                locator = {
                  fuzzy_threshold = 0.8,
                  enable_fuzzy_matching = true,
                },
                ui = {
                  go_to_origin_on_complete = true,
                  keybindings = {
                    accept = ".",
                    reject = ",",
                    next = "n",
                    prev = "p",
                    accept_all = "ga",
                    reject_all = "gr",
                  },
                },
              },
            },
            ui = {
              window = {
                width = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
                height = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
                align = "center", -- "center", "top-left", "top-right", "bottom-left", "bottom-right", "top", "bottom", "left", "right"
                relative = "editor",
                zindex = 50,
                border = "rounded", -- "none", "single", "double", "rounded", "solid", "shadow"
              },
              wo = { -- window-scoped options (vim.wo)
                winhl = "Normal:MCPHubNormal,FloatBorder:MCPHubBorder",
              },
            },
            json_decode = nil, -- Custom JSON parser function (e.g., require('json5').parse for JSON5 support)
            on_ready = function(hub)
              -- Called when hub is ready
            end,
            on_error = function(err)
              -- Called on errors
            end,
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

return {
  {
    "Saghen/blink.cmp",
    optional = true,
    opts = {
      keymap = {
        preset = "enter",
        ["<C-o>"] = { "show" },
        ["<Tab>"] = {
          LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
          "fallback",
        },
      },
      completion = {
        menu = {
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "source_name" },
            },
            treesitter = {},
          },
        },
      },
      sources = {
        compat = {},
        -- Add 'avante' to the list
        default = { "avante", "lsp", "path", "buffer" },
        providers = {
          avante = {
            module = "blink-cmp-avante",
            name = "Avante",
            opts = {
              -- options for blink-cmp-avante
            },
          },
        },
      },
    },
    dependencies = {
      "Kaiser-Yang/blink-cmp-avante",
    },
  },
  {
    dir = "~/workspaces/nvim/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      provider = "deepseek",
      auto_suggestions_provider = "code",
      cursor_applying_provider = "siliconflow",
      behaviour = {
        auto_suggestions = false, -- Experimental stage
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = true,
        support_paste_from_clipboard = false,
        minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
        enable_token_counting = true, -- Whether to enable token counting. Default to true.
        enable_cursor_planning_mode = false, -- Whether to enable Cursor Planning Mode. Default to false.
      },
      web_search_engine = {
        disable_tools = true,
      },
      vendors = {
        code = {
          __inherited_from = "openai",
          api_key_name = "",
          endpoint = "http://localhost:11434/v1",
          model = "starcoder2:3b",
        },
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com",
          model = "deepseek-chat",
          temperature = 0,
        },
        siliconflow = {
          __inherited_from = "openai",
          api_key_name = "SILICONFLOW_API_KEY",
          endpoint = "https://api.siliconflow.cn/v1",
          model = "Qwen/Qwen2.5-7B-Instruct",
          temperature = 0,
        },
        gpustack = {
          __inherited_from = "openai",
          api_key_name = "GPUSTACK_API_KEY",
          endpoint = "http://100.64.0.1:9180/v1",
          model = "qwen2.5",
          temperature = 0,
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
        enabled = true, -- Enables the rag service, requires OPENAI_API_KEY to be set
        provider = "ollama",
        endpoint = "http://172.17.0.1:11434",
        llm_model = "deepseek-r1",
        embed_model = "EntropyYue/jina-embeddings-v2-base-zh",
      },
      custom_tools = {
        {
          name = "run_go_tests",
          description = "Run Go unit tests and return results",
          command = "go test -v ./...",
          param = {
            type = "table",
            fields = {},
          },
          returns = {
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
          func = function()
            return vim.fn.system(string.format("go test -v ./..."))
          end,
        },
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
    },
  },
}

return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig" -- ваш файл с настройками
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "vim", "lua", "cpp", "c", "cmake" },
    },
  },


  {
    "Civitasv/cmake-tools.nvim",
    event = "VeryLazy",
    dependencies = { "stevearc/overseer.nvim" },
    opts = {
      cmake_executor = {
        name = "overseer",
        opts = {
          new_task_opts = {
            components = {
              "default", -- включает on_exit_set_status (нужен для завершения таски)
              {
                "on_output_parse",
                -- errorformat для gcc/clang:
                errorformat = "%f:%l:%c: %trror: %m",
              },
              "on_result_diagnostics",
            },
          },
          on_new_task = function(task)
            require("overseer").open({ enter = false, direction = "bottom" })
          end,
        },
      },
      cmake_runner = { name = "overseer" }, -- Запуск программы в панели Overseer
      cmake_notifications = { runner = { enabled = true } },
      cmake_generate_options = { "-G", "Ninja" },
      save_before_run = false,
      post_build_save_before_run = false, -- ← ADD THIS
    },
  },
  {
    "stevearc/overseer.nvim",
    opts = {
      task_list = {
        direction = "bottom",
      },
    },
  },

  {
    "stevearc/dressing.nvim",
    lazy = false,
    opts = {},
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "folke/trouble.nvim",
    opts = {
      win = {
        position = "bottom", -- как у Overseer
        size = 0.15,
      },
    },
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    event = "VeryLazy",

    config = function()
      vim.g.maplocalleader = ","
      require("grug-far").setup {}
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    build = "make install_jsregexp",
    config = function()
      require "nvchad.configs.luasnip"
      require("luasnip.loaders.from_vscode").lazy_load {
        paths = { vim.fn.stdpath "config" .. "/lua/snippets" },
      }
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost",
    opts = {
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
    },
    config = function(_, opts)
      local ufo = require "ufo"
      ufo.setup(opts)

      vim.api.nvim_create_autocmd("BufReadPost", {
        callback = function()
          ufo.openAllFolds()
        end,
      })
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {
      lsp = {
        hover = { enabled = true },
        signature = {
          enabled = true,
          auto_open = { enabled = false }, 
          opts = { 
            focus = false, 
            focusable = false 
  }, 
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.set_autocmds_to_reply_to_context"] = true,
          ["interface.hover"] = true,
        },
      },
      views = {
        hover = {
          focusable = false,
          focus = false,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
      },
    },
{
  "p00f/clangd_extensions.nvim",
  config = function()
    require("clangd_extensions").setup({
      symbol_info = {
        border = "rounded",  -- Optional styling
        -- Add height/width here if supported, or hook vim.lsp.util.open_floating_preview
      },
    })
  end,
},
  -- Mason DAP для автоматической установки codelldb
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      automatic_installation = true,
      handlers = {
        function(config)
          require("mason-nvim-dap").default_setup(config)
        end,
        codelldb = function(config)
          config.adapters = {
            type = "server",
            host = "127.0.0.1",
            port = "${port}",
            executable = {
              command = "codelldb",
              args = { "--port", "${port}" },
            },
          }
          require("mason-nvim-dap").default_setup(config)
        end,
      },
    },
  },
{
    "mg979/vim-visual-multi",
    lazy = false, 
    init = function()
        vim.g.VM_maps = {
            ["Find Under"] = "", 
        }
        vim.g.VM_mouse_mappings = 1
    end,
},

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "jay-babu/mason-nvim-dap.nvim",
      "igorlfs/nvim-dap-view",
    },
    config = function()
      local dap = require("dap")
      local dap_view = require("dap-view")

      dap_view.setup()

    dap.adapters.gdb = {
      type = "executable",
      command = "/opt/Xilinx/Vitis/2024.2/gnu/aarch32/lin/gcc-arm-none-eabi/bin/arm-none-eabi-gdb", -- Замените на путь к вашему xilinx-gdb (напр. mb-gdb)
      args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
    }
      -- Автоматическое открытие/закрытие интерфейса отладки
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dap_view.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dap_view.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dap_view.close()
      end

  -- Общая функция для получения пути из CMake (чтобы не дублировать код)
      local get_cmake_bin = function()
        local ok, cmake = pcall(require, "cmake-tools")
        if not ok then
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
        end
        local target_name = cmake.get_build_target()
        local build_dir = cmake.get_build_directory()
        if not target_name or target_name == "" then
          return vim.fn.input("Path to executable: ", build_dir or (vim.fn.getcwd() .. "/build/"), "file")
        end
        return build_dir .. "/" .. target_name
      end

      -- 2. Настройка конфигураций
      dap.configurations.cpp = {
        -- СТАНДАРТНЫЙ X86 (уже был у вас)
        {
          name = "x86: Launch CMake Target (codelldb)",
          type = "codelldb",
          request = "launch",
          program = get_cmake_bin,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          console = "integratedTerminal",
        },
        -- XILINX GDB (НОВЫЙ)
        {
          name = "Xilinx: Remote Debug (GDB)",
          type = "xilinx",
          request = "launch",
          program = get_cmake_bin, -- Использует тот же ELF из CMake
          cwd = "${workspaceFolder}",
          -- Адрес HW Server / GDB Server (по умолчанию 3333)
          target = "localhost:3333", 
          miDebuggerPath = "/opt/Xilinx/Vitis/2024.2/gnu/aarch32/lin/gcc-arm-none-eabi/bin/arm-none-eabi-gdb", -- Дублируем путь к GDB
          setupCommands = {
            { text = "-enable-pretty-printing", description = "enable pretty printing", ignoreFailures = false },
            -- Если нужно автоматически загружать прошивку, раскомментируйте:
            { text = "load", description = "load target", ignoreFailures = false },
          },
        },
      }

      dap.configurations.c = dap.configurations.cpp

      -- Авто-интерфейс
      dap.listeners.after.event_initialized["dapui_config"] = function() dap_view.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dap_view.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dap_view.close() end
    end  },
}

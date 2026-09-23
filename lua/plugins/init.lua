return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    lazy = false, -- грузим сразу, чтобы clangd подхватывался уже в первом файле
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig" -- ваш файл с настройками
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "vim", "lua", "cpp", "c", "cmake", "markdown", "markdown_inline" },
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

      dap_view.setup({
        auto_toggle = true, -- окно само открывается на старте сессии и закрывается на terminate
        virtual_text = { enabled = true, position = "inline" }, -- значения переменных прямо в коде
        winbar = {
          show = true,
          -- как в IDE: переменные / watch / стек вызовов / брейкпоинты / консоль (REPL)
          sections = { "scopes", "watches", "threads", "breakpoints", "repl" },
          default_section = "scopes",
          show_keymap_hints = true,
          controls = { enabled = true, position = "right" }, -- панель кнопок play/step/stop
        },
        windows = {
          size = 0.3,
          position = "right", -- панель справа, а не снизу
          terminal = { size = 0.4, position = "below" },
        },
        render = {
          threads = { align = true },
          breakpoints = { align = true },
        },
      })

      -- Красивые знаки в гуттере + подсветка текущей строки выполнения.
      -- Nerd Font-альтернативы: breakpoint "" , stopped "" , log/condition "" .
      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e06c75" })
      vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#e5c07b" })
      vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" })
      vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#5c6370" })
      vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379", bold = true })
      vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2c323c" }) -- строка, где остановился gdb

      local dap_signs = {
        DapBreakpoint = { text = "●", texthl = "DapBreakpoint", numhl = "DapBreakpoint" },
        DapBreakpointCondition = { text = "◆", texthl = "DapBreakpointCondition" },
        DapLogPoint = { text = "◆", texthl = "DapLogPoint" },
        DapBreakpointRejected = { text = "✖", texthl = "DapBreakpointRejected" },
        DapStopped = { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "DapStopped" },
      }
      for name, opts in pairs(dap_signs) do
        vim.fn.sign_define(name, opts)
      end

      -- Цвета DAP-hover: имя/выражение акцентом, изменённое значение — жёлтым
      vim.api.nvim_set_hl(0, "NvimDapViewWatchExpr", { fg = "#7cafc2", bold = true })
      vim.api.nvim_set_hl(0, "NvimDapViewWatchUpdated", { fg = "#e5c07b" })

      -- gdb говорит на DAP нативно (нужен gdb >= 14).
      -- command меняется на нужный кросс-gdb: xtensa-esp-elf-gdb / arm-none-eabi-gdb / riscv32-esp-elf-gdb
      local gdb_adapter = {
        type = "executable",
        command = "gdb",
        args = { "-q", "--interpreter=dap", "--eval-command=set print pretty on" },
      }
      dap.adapters.gdb = gdb_adapter

      -- gdbserver: сами поднимаем `gdbserver --attach <pid>` и подключаемся к нему.
      -- PID приходит из конфигурации (process_id); gdb подключается через `target remote`.
      -- Порт по умолчанию 0 = ОС сама выберет свободный (не конфликтуем с чужим сервером на 3333).
      local gdbserver_jobs = {}
      dap.adapters.gdbserver = function(cb, config)
        local port = config.gdbserver_port or 0
        local pid = config.process_id
        if not pid or pid == require("dap").ABORT then
          vim.notify("gdbserver: PID не выбран", vim.log.levels.ERROR)
          return
        end

        local output = ""
        local actual_port, failed
        local on_output = function(_, data)
          if not data then
            return
          end
          output = output .. table.concat(data, "\n")
          local p = output:match("Listening on port (%d+)")
          if p then
            actual_port = tonumber(p)
          end
          if output:match("Operation not permitted") or output:match("Can't bind address") or output:match("Exiting") then
            failed = true
          end
        end
        local job = vim.fn.jobstart(
          { "gdbserver", "--attach", ("127.0.0.1:%d"):format(port), tostring(pid) },
          { on_stdout = on_output, on_stderr = on_output }
        )
        if job <= 0 then
          vim.notify("gdbserver: не запустился (установлен ли gdbserver?)", vim.log.levels.ERROR)
          return
        end
        gdbserver_jobs[job] = true

        vim.wait(5000, function() return actual_port ~= nil or failed end, 50)

        if failed or not actual_port then
          vim.fn.jobstop(job)
          gdbserver_jobs[job] = nil
          local hint = ""
          if output:match("already traced by") then
            hint = "\n\nПроцесс уже отлаживается другим gdb/gdbserver. "
              .. "Подключитесь к существующему серверу конфигурацией 'Attach to gdb server' "
              .. "или завершите старый отладчик."
          elseif output:match("Operation not permitted") then
            hint = "\n\nНужен ptrace: sudo sysctl -w kernel.yama.ptrace_scope=0"
          end
          vim.notify("gdbserver не подключился:\n" .. output .. hint, vim.log.levels.ERROR)
          return -- не подключаем gdb к чужому/несуществующему серверу
        end

        config.target = ("127.0.0.1:%d"):format(actual_port) -- gdb выполнит `target remote`
        config.process_id = nil -- чтобы gdb не делал локальный attach по pid
        cb(gdb_adapter)
      end

      -- Гасим поднятые gdbserver при завершении сессии
      local stop_gdbservers = function()
        for job in pairs(gdbserver_jobs) do
          vim.fn.jobstop(job)
          gdbserver_jobs[job] = nil
        end
      end
      dap.listeners.before.event_terminated["gdbserver_cleanup"] = stop_gdbservers
      dap.listeners.before.event_exited["gdbserver_cleanup"] = stop_gdbservers
      -- Открытием/закрытием dap-view управляет auto_toggle (см. dap_view.setup выше)

  -- Общая функция для получения пути из CMake (чтобы не дублировать код)
      local get_cmake_bin = function()
        local ok, cmake = pcall(require, "cmake-tools")
        if not ok then
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
        end

        -- 1) Штатный путь: если выбрана launch-цель, cmake-tools вернёт готовый путь
        local ok_path, path = pcall(cmake.get_launch_target_path)
        if ok_path and type(path) == "string" and path ~= "" then
          return path
        end

        -- 2) Собираем путь сами: build_directory + имя цели.
        --    build_directory может содержать ${variant:buildType}, а get_build_target()
        --    возвращает СПИСОК целей (таблицу), а не строку.
        local ok_fallback, full = pcall(function()
          local dir_obj = cmake.get_build_directory()
          local dir = dir_obj and tostring(dir_obj) or nil
          if not dir then
            return nil
          end
          local build_type = cmake.get_build_type()
          if type(build_type) == "string" then
            dir = dir:gsub("${variant:buildType}", build_type)
          end
          dir = dir:gsub("${[^}]*}", "") -- остатки плейсхолдеров

          local target = cmake.get_launch_target()
          if type(target) ~= "string" or target == "" then
            target = cmake.get_build_target()
            if type(target) == "table" then
              target = target[1]
            end
          end
          if type(target) ~= "string" or target == "" then
            return nil
          end
          return dir .. "/" .. target
        end)

        if ok_fallback and type(full) == "string" and vim.fn.filereadable(full) == 1 then
          return full
        end

        -- 3) Ручной ввод
        local default = (ok_fallback and type(full) == "string" and full) or (vim.fn.getcwd() .. "/build/")
        return vim.fn.input("Path to executable: ", default, "file")
      end

      -- Выбор PID процесса цели: фильтруем список по имени бинаря и исключаем сам gdbserver
      local pick_target_process = function()
        local bin = get_cmake_bin()
        local name = vim.fn.fnamemodify(bin, ":t")
        return require("dap.utils").pick_process({
          filter = function(proc)
            return proc.name:find(name, 1, true) ~= nil and proc.name:find("gdbserver", 1, true) == nil
          end,
        })
      end

      -- 2. Настройка конфигураций
      dap.configurations.cpp = {
        -- Attach к живому процессу: сами поднимаем `gdbserver --attach <pid>`.
        -- PID выбирается из списка процессов (dap.utils.pick_process).
        {
          name = "Attach by PID (gdbserver)",
          type = "gdbserver",
          request = "attach",
          process_id = pick_target_process,
          program = get_cmake_bin, -- ELF для символов
          cwd = "${workspaceFolder}",
          gdbserver_port = 0, -- 0 = свободный порт выбирает ОС; задайте число для фиксированного
        },
        -- Подключение к уже запущенному gdb-серверу (OpenOCD / JLink / gdbserver).
        -- gdb выполнит: target remote <host:port>
        {
          name = "Attach to gdb server",
          type = "gdb",
          request = "attach",
          target = function()
            return vim.fn.input("gdb server (host:port): ", "localhost:3333")
          end,
          program = get_cmake_bin, -- ELF с символами (для embedded обязателен)
          cwd = "${workspaceFolder}",
        },
        -- Обычный локальный запуск (нативный x86-64 gdb)
        {
          name = "Launch (gdb)",
          type = "gdb",
          request = "launch",
          program = get_cmake_bin,
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
        },
        -- Attach к локальному процессу по pid
        {
          name = "Attach to process (pid)",
          type = "gdb",
          request = "attach",
          program = get_cmake_bin,
          pid = pick_target_process,
          cwd = "${workspaceFolder}",
        },
        -- Нативный запуск через codelldb (нужен mason codelldb)
        {
          name = "Launch CMake Target (codelldb)",
          type = "codelldb",
          request = "launch",
          program = get_cmake_bin,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      dap.configurations.c = dap.configurations.cpp
    end,
  },

  -- Брейкпоинты сохраняются между запусками nvim
  {
    "Weissle/persistent-breakpoints.nvim",
    event = "BufReadPost",
    opts = {
      load_breakpoints_event = { "BufReadPost" },
    },
  },
}

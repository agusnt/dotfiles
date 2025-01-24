-- DAP configuration
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

return {
  'theHamsta/nvim-dap-virtual-text',
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    config = function()
      -- DAP-UI
      local dap, dapui = require("dap"), require("dapui")

      -- Configure adapters
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = "codelldb",
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            return '/usr/bin/python'
          end,
        },
      }

      -- Configurations
      dap.configurations.cpp = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
          runInTerminal = true,
        }
      }

      -- Listeners
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      -- Setup
      dapui.setup({
        controls = {
          element = "repl",
          enabled = true,
          icons = {
            disconnect = "",
            pause = "󰏤",
            play = "",
            run_last = "",
            step_back = "",
            step_into = "",
            step_out = "",
            step_over = "",
            terminate = ""
          }
        },
        expand_lines = true,
        floating = {
          border = "double",
          mappings = {
            close = { "q", "<Esc>" }
          }
        },
        force_buffers = true,
        icons = {
          collapsed = "<U+EB70>",
          current_frame = "<U+EB70>",
          expanded = "<U+EB6E>"
        },
        layouts = { {
          elements = { {
            id = "scopes",
            size = 0.35
          }, {
            id = "breakpoints",
            size = 0.35
          }, {
            id = "stacks",
            size = 0.35
          }, {
            id = "watches",
            size = 0.35
          } },
          position = "left",
          size = 50
        }, {
          elements = { {
            id = "repl",
            size = 0.5
          }, {
            id = "console",
            size = 0.5
          } },
          position = "bottom",
          size = 10
        } },
        mappings = {
          edit = "e",
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          repl = "r",
          toggle = "t"
        },
        render = {
          indent = 2,
          max_value_lines = 100
        }
      })

      require('nvim-dap-virtual-text').setup()
    end
  }
}

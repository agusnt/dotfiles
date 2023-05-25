-- LuaLine
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

require('lualine').setup{
    options =
    {
        icons_enabled = true,
        theme = 'gruvbox-material',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
    },
    sections =
    {
        lualine_a = {'mode'},
        lualine_b = {'branch'},
        lualine_c = {
            {
                'buffers',
                mode = 4,
                max_length = vim.o.columns * 2 / 3,
                buffers_color = {
                    active = { bg = '#473c29', fg = '#d4be98'}
                },
                symbols = { alternate_file = '' },
            }
        },
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {},
        lualine_z = {},
    },
}

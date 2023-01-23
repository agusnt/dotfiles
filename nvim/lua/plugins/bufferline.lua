-- Bufferline
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com, agusnt@unizar.es

require("bufferline").setup{
    options = {
        diagnostics = "nvim_lsp",
        separator_style = {"", ""},
        modified_icon = '●',
        numbers = "buffer_id",
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_default_icon = true,
        show_tab_indicators = true,
    }
}

# fzf-lua-foldmarkers
Fold markers picker for fzf-lua.

## Prerequisites
<ul>
  <li>NeoVim (tested with version 0.11.4)</li>
  <li><a href="https://github.com/ibhagwan/fzf-lua" target="_blank">fzf-lua</a></li>
</ul>

## Installation
Install this using your favorite package manager. For example using <a href="https://github.com/folke/lazy.nvim" target="_blank">lazy.nvim</a>:
```lua
{
  "ibhagwan/fzf-lua",
  dependencies = {
    "neur1n/fzf-lua-foldmarkers",
  },
},
```

## Configuration
```lua
require("fzf-lua-foldmarkers").setup({
    -- Optional. Will be called after jumping to a fold marker.
    on_jump = function()
      ...
    end,
})
```

## Usage
Example keybinding to invoke the fold markers picker:
```lua
{"<Leader>fm", "<Cmd>lua require('fzf-lua-foldmarkers').foldmarkers()<CR>", mode = "n", {noremap = true, silent = true}},
```

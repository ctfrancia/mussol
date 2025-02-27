# mussol
a Neovim plugin

The plugin is a sorter and easily to find your "FIXME" or "TODO" notes in a project and make them sortable as well as create your own tags and importance?
I don't know this project is in it's infancy. More of a learning Lua project with Neovim so as of right now it's nothing more than just tailord for me.

## Installation
### Packer
```lua
use 'ctfrancia/mussol'
```
 
## Requirements
- plenary.nvim

## Usage
structured for Lazy
```lua
{
    "github.com/ctfrancia/mussol",
    opts = {
        targets = {
            { name = "TODO",  wt = 2,  fg = "orange", bg = "none" },
            { name = "FIXME", wt = 10, fg = "yellow", bg = "none" },
            { name = "BUG",   wt = 8,  fg = "red",    bg = "none" },
            { name = "NOTE",  wt = 1,  fg = "blue",   bg = "none" },
        }
    }
}
```
- `name` is the tag you want to search for.
- `wt` is the weight of the tag.
- `fg` is the foreground color of the tag.
- `bg` is the background color of the tag.

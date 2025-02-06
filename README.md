# mussol
a Neovim plugin

The plugin is a sorter and easily to find your "FIXME" or "TODO" notes in a project and make them sortable as well as create your own tags and importance?
I don't know this project is in it's infancy. More of a learning Lua project with Neovim so as of right now it's nothing more than just tailord for me.

## Installation
### Packer
```lua
use 'github.com/ctfrancia/mussol'
```
 
## Requirements
- plenary.nvim

## Usage
```lua
require('mussol').setup()
```
`setup` takes a table with the following options:

```lua
```
- `name` is the name of the config
- `path` is the path where the custom config is located
  - default is `~/.config/nvim/mussol`
- `targets` is a table of strings that will be used to search, sort, and highlight
  - default is { "TODO", "FIXME", "BUG", "NOTE" }
- `highlight` is a table of tables that will be used to highlight the targets (not implemented yet)
  - default is the table above

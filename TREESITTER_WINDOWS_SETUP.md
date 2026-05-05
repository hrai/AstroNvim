# AstroNvim v6 - Cross-Platform Configuration

## Platform Detection
This configuration automatically detects your platform and adjusts accordingly:

### ✅ Windows (Current)
- **Syntax Highlighting**: Treesitter (with MSVC compiler)
- **Treesitter**: Enabled with Visual Studio MSVC compiler
- **LSP**: Full support via Mason
- **Completion**: blink.cmp v2 with blink.lib
- **Status**: All features including treesitter

### ✅ WSL/Linux
- **Syntax Highlighting**: Treesitter
- **Treesitter**: Fully enabled with auto-install
- **Treesitter Textobjects**: Enabled
- **LSP**: Full support via Mason
- **Completion**: blink.cmp v2 with blink.lib
- **Status**: All features including treesitter

## How It Works

The configuration uses platform detection:
```lua
local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
```

**On Windows:**
- Treesitter plugins are disabled
- Vim syntax highlighting is enabled
- No compilation attempts

**On WSL/Linux:**
- Treesitter plugins are fully enabled
- Auto-install parsers
- Treesitter textobjects work

## Features by Platform

| Feature | Windows | WSL/Linux |
|---------|---------|-----------|
| Syntax Highlighting | Vim syntax | Treesitter |
| LSP | ✅ | ✅ |
| Code Completion | ✅ | ✅ |
| Go to Definition | ✅ | ✅ |
| Find References | ✅ | ✅ |
| Treesitter Textobjects | ❌ | ✅ |
| Treesitter Highlight | ❌ | ✅ |
| Mason Tools | ✅ | ✅ |

## Sync Your Config

Since you use the same config in both environments:

1. **Windows**: Edit config here, commit changes
2. **WSL**: Pull changes, treesitter works automatically
3. **No separate configs needed** - platform detection handles it

```bash
# In your nvim config directory
git add .
git commit -m "Update config"
git push

# In WSL
cd ~/.config/nvim  # or your nvim config location
git pull
```

## Windows Treesitter Setup with MSVC

Treesitter now works on Windows using the Visual Studio MSVC compiler!

### Requirements
- Visual Studio 2022 (or Visual Studio Build Tools)
- MSVC compiler (cl.exe) installed

### Configuration
The config automatically detects and uses MSVC by searching:
- Visual Studio 2026 or 2022 Professional edition only
- `C:/Program Files/Microsoft Visual Studio` location
- Latest installed MSVC toolchain version
- Multiple host/target architectures (x64/x86)

### How It Works
1. Searches for Visual Studio installations
2. Finds the latest MSVC toolchain version
3. Adds MSVC compiler to PATH automatically
4. Configures Treesitter to use `cl` compiler
5. Parsers compile automatically on `:TSUpdate`

### Alternative: Use WSL
If you prefer, you can still use WSL for treesitter features and Windows for quick editing with Vim syntax.

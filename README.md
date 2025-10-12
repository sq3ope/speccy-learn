1. Visual Studio Code setup
Install extensions:
* code --install-extension mborik.z80-macroasm

Add configuration to settings.json:
```json
"[z80-macroasm]": {
        "editor.tabSize": 8,
        "editor.insertSpaces": true,
        "editor.rulers": [16, 24, 48],
        "files.eol": "\n",

        // disables color swatches or "pigments" on minimap because
        // hex-values starting with `#` are common number format in asm
        "editor.colorDecorators": false,

        // formatting while typing a code (disable if you find it intrusive)
        "editor.formatOnType": true,
        "editor.formatOnSave": true,
        "files.trimTrailingWhitespace": true,
    },

    "z80-macroasm.format.enabled": true,
    "z80-macroasm.format.baseIndent": 2,
    "z80-macroasm.format.controlIndent": 1,
    "z80-macroasm.format.spaceAfterArgument": true,
    "z80-macroasm.format.spacesAroundOperators": true,
    "z80-macroasm.format.colonAfterLabels": "no-change"
```

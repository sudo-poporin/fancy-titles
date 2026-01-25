# Backups

This folder contains original font files before subsetting optimization.

## Fonts

- `fonts/EVA-Matisse_Classic-original.ttf` - Original EVA-Matisse Classic font (6.2MB)
- `EVA-Matisse_Standard.ttf` - Was deleted (7MB, never used in code)

## Why subsetting?

The original EVA-Matisse fonts contain ~8,700 glyphs including:
- 6,720 CJK (Kanji) characters
- 90 Hiragana characters
- 94 Katakana characters
- 223 Latin characters

The package only uses Latin characters for titles like "NEON GENESIS EVANGELION".

The subset version contains only ASCII characters needed for English text,
reducing the font from 6.2MB to 16KB (99.7% reduction).

## Recreating the subset

```bash
pip3 install fonttools

CHARS="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .:!?'-+*/_@#\$%&()[]{}\"<>,;=\\"

pyftsubset "backups/fonts/EVA-Matisse_Classic-original.ttf" \
  --text="$CHARS" \
  --output-file="lib/fonts/EVA-Matisse_Classic.ttf" \
  --drop-tables+=gasp \
  --layout-features='*' \
  --no-hinting
```

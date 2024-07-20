# Memory map

## IRAM

Internal RAM space is used and managed by the BIOS component.

^ Start ^ End ^ Description ^
| 0x0000 | 0x00FF | Interrupt vectors (INT 00 ~ INT 3F) |
| 0x0E00 | 0x3FFF | Screen, sprite, tile data |
| 0x4000 | 0xBFFF | Tile data (Color) |
| 0xC000 | 0xFDFF | Unused/possibly used by user programs? (Color) |
| 0xFE00 | 0xFFFF | Palette data (Color) |

## SRAM

Save RAM space is used and managed by the OS component.

## ROM

^ Start ^ End ^ Description ^
| 0x40000, 0x80000, ... | 0xDFFFF | User data space |
| 0xE0000 | 0xEFFFF | OS component area |
| 0xF0000 | 0xFFFEF | BIOS component area |
| 0xFFFF0 | 0xFFFFF | Cartridge footer |

--@name Constants
--@client

FREQUENCY = 4194304

ADDR_CARTRIDGE_TYPE   = 0x0147 -- MBC type
ADDR_ROM_SIZE         = 0x0148 
ADDR_RAM_SIZE         = 0x0149

ADDR_JOYPAD           = 0xFF00
ADDR_LCDC             = 0xFF40
ADDR_STAT             = 0xFF41
ADDR_SCY              = 0xFF42
ADDR_SCX              = 0xFF43 
ADDR_LY               = 0xFF44
ADDR_LYC              = 0xFF45 
ADDR_DMA              = 0xFF46
ADDR_BG_PALETTE       = 0xFF47
ADDR_SPRITE_PALETTE   = {0xFF48, 0xFF49}
ADDR_WINDOW_Y         = 0xFF4A
ADDR_WINDOW_X         = 0xFF4B
ADDR_BOOT_ROM_DISABLE = 0xFF50

-- Serial:
ADDR_SB = 0xFF01
ADDR_SC = 0xFF02

-- Interrupts:
ADDR_IF   = 0xFF0F
ADDR_IE   = 0xFFFF

-- Timers:
ADDR_TAC  = 0xFF07 
ADDR_TIMA = 0xFF05
ADDR_TMA  = 0xFF06
ADDR_DIV  = 0xFF04

ADDR_ROM_SIZE = 0x0148 
ADDR_RAM_SIZE = 0x0149 

local BOOT_ROM_RAW = http.base64Decode("Mf7/ryH/nzLLfCD7ISb/DhE+gDLiDD7z4jI+d3c+/OBHEQQBIRCAGs2VAM2WABN7/jQg8xHYAAYIGhMiIwUg+T4Z6hCZIS+ZDgw9KAgyDSD5Lg8Y82c+ZFfgQj6R4EAEHgIODPBE/pAg+g0g9x0g8g4TJHweg/5iKAYewf5kIAZ74gw+h+LwQpDgQhUg0gUgTxYgGMtPBgTFyxEXwcsRFwUg9SIjIiPJzu1mZswNAAsDcwCDAAwADQAIER+IiQAO3Mxu5t3d2Zm7u2djbg7szN3cmZ+7uTM+PEK5pbmlQjwhBAERqAAaE74g/iN9/jQg9QYZeIYjBSD7hiD+PgHgUA==")

BOOT_ROM = {}
for i = 1, #BOOT_ROM_RAW do
    BOOT_ROM[i] = string.byte(BOOT_ROM_RAW:sub(i, i))
end
assert(#BOOT_ROM == 0x100, string.format("boot rom must be 0x100 bytes long, is 0x%X bytes long", #BOOT_ROM))


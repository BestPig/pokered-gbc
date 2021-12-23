SECTION "rst0", ROM0[$0000]
_LoadMapVramAndColors:
	ldh a, [hLoadedROMBank]
	push af
	ld a, BANK(LoadMapVramAndColors)
	ld [MBC1RomBank], a
	call LoadMapVramAndColors
	pop af
	ld [MBC1RomBank], a
	ret

;SECTION "rst8", ROM0[$0008]

; HAX: rst10 is used for the vblank hook
SECTION "rst10", ROM0[$0010]
	ld b, BANK(GbcVBlankHook)
	ld hl, GbcVBlankHook
	jp Bankswitch

; HAX: rst18 can be used for "Bankswitch"
SECTION "rst18", ROM0[$0018]
	jp Bankswitch

; memory for rst vectors $20-$38 used by color hack

SetRomBank::
	ldh [hLoadedROMBank], a
	ld [MBC1RomBank], a
	ret


; Game Boy hardware interrupts

SECTION "vblank", ROM0[$0040]
	push hl
	ld hl, VBlank
	jp InterruptWrapper

SECTION "lcd", ROM0[$0048] ; HAX: interrupt wasn't used in original game
	push hl
	ld hl, _GbcPrepareVBlank
	jp InterruptWrapper

SECTION "timer", ROM0[$0050]
	push hl
	ld hl, Timer
	jp InterruptWrapper

SECTION "serial", ROM0[$0058]
	push hl
	ld hl, Serial
	jp InterruptWrapper

SECTION "joypad", ROM0[$0060]
	reti


SECTION "Header", ROM0[$0100]

Start::
jp InitializeColor
db $00

; The Game Boy cartridge header data is patched over by rgbfix.
; This makes sure it doesn't get used for anything else.

; analogue pocket logo
    db   $01,$10,$CE,$EF,$00,$00,$44,$AA 
    db   $00,$74,$00,$18,$11,$95,$00,$34 
    db   $00,$1A,$00,$D5,$00,$22,$00,$69 
    db   $6F,$F6,$F7,$73,$09,$90,$E1,$10 
    db   $44,$40,$9A,$90,$D5,$D0,$44,$30 
    db   $A9,$21,$5D,$48,$22,$E0,$F8,$60

	ds $0150 - @

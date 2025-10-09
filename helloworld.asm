org $8000

ld hl, $4000
ld (hl), $ff

ld hl, msg

loop:
ld a, (hl)  ; read next character
or a        ; is character == 0?
jr z, exit
rst $10     ; print character
inc hl
jr loop

exit:
ret

msg: defm 'Hello ZX Spectrum Assembly!', $00

end $8000

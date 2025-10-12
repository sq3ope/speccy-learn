; ===========================
; Wait for any key press
; ===========================
wait_key:
                ld      bc, 0xfefe              ; start scanning keyboard rows
row_loop:
                in      a, (c)                  ; read a row
                and     0x1f                    ; mask lower 5 bits (active low)
                cp      0x1f                    ; 0x1f = no keys pressed in this row
                jr      nz, key_pressed         ; if any bit cleared → key pressed
                rlc     b                       ; rotate next row bit into position
                jr      c, row_loop             ; check all 8 keyboard lines (bits 0–7)
                jr      wait_key                ; none pressed → repeat

key_pressed:
                ret

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

;------------------------------------------------------------------
; ScanKeys
; Scans the control keys and returns the pressed keys.
; Output: D -> Keys pressed.
;         Bit 0 -> Q pressed 0/1.
;         Bit 1 -> A pressed 0/1.
;         Bit 2 -> O pressed 0/1.
;         Bit 3 -> P pressed 0/1.
; Alters the value of the AF and D registers.
;------------------------------------------------------------------
ScanKeys:
                ld      d, $00                  ; Sets the D register to 0

scanKeys_Q:
                ld      a, $fb                  ; Load in A the Q-T half-stack
                in      a, ($fe)                ; Read status of the semi-stack
                bit     $00, a                  ; Checks if the Q has been pressed
                jr      nz, scanKeys_A          ; If not clicked, skips
                set     $00, d                  ; Set the bit corresponding to Q to one

scanKeys_A:
                ld      a, $fd                  ; Load in A the A-G half-stack
                in      a, ($fe)                ; Read status of the half-stack
                bit     $00, a                  ; Checks whether A has been pressed
                jr      nz, scanKeys_O          ; If not clicked, skips
                set     $01, d                  ; Sets the bit corresponding to A to one

; Check that the two arrow keys have not been pressed
                ld      a, d                    ; Load the value of D into A
                sub     $03                     ; Checks whether Q and A have been pressed
                                                ; at the same time
                jr      nz, scanKeys_O          ; If not pressed, skips
                ld      d, a                    ; Sets D to zero

scanKeys_O:
                ld      a, $df                  ; Load the half-stack P-Y
                in      a, ($fe)                ; Read status of the semi-stack
                bit     $01, a                  ; Checks if O has been pressed
                jr      nz, scanKeys_P          ; If not pressed, skip
                set     $02, d                  ; Set the bit corresponding to O to a one

scanKeys_P:
                ; Already have state of the P-Y half-stack in A
                bit     $00, a                  ; Checks if the P has been pressed
                ret     nz                      ; If not pressed, nothing more to do - returns
                set     $03, d                  ; Sets the bit corresponding to P to one

; Check that the two arrow keys have not been pressed
                ld      a, d                    ; Load the value of D into A
                and     $0c                     ; Keeps the O and P bits
                cp      $0c                     ; Check if the two keys have been pressed
                ret     nz                      ; If they have not been pressed, it exits
                ld      a, d                    ; Pressed, loads the value of D in A
                and     $03                     ; Takes the bits of Q and A
                ld      d, a                    ; Load the value in D

                ret

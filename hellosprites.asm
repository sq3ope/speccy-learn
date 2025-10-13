                org     $8000

                ld      a, 0                    ; A = colour attributes
                ld      hl, ATTR_T              ; HL = address current attributes
                ld      (hl), a                 ; Load into memory
                ld      hl, ATTR_S              ; HL = address permanent attributes
                ld      (hl), a                 ; Load into memory

                call    CLS                     ; Clear screen: use ATTR_S

                call    draw_chessboard         ; Draw chessboard on screen

                ld      a, 7                    ; A = border colour
                out     ($fe), a                ; Change border colour

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;010$TT$SSS$LLL$CCCCC
                ld      hl, %010$01$000$100$10000 ; screen memory center address

                ld      de, frog_up             ; up frog shape
                push    hl
                call    drwfrg
                pop     hl

scanKeysLoop:
                call    ScanKeys                ; read keys pressed
testQKey:
                bit     0, d                    ; test Q key
                jr      z, testAKey             ; if not pressed, test A key
                ld      a, l                    ; move frog up
                sub     %100000                 ; move up one row
                ld      l, a
                jr      nc, drawFrog            ; no need to change third
                ld      a, h                    ; handle third wrap
                sub     %1000                   ; move to previous third
                ld      h, a
                jr      drawFrog
testAKey:
                bit     1, d                    ; test A key
                jr      z, testOKey             ; if not pressed, test O key
                ld      a, l                    ; move frog down
                add     a, %100000              ; move down one row
                ld      l, a
                jr      nc, drawFrog            ; no need to change third
                ld      a, h                    ; handle third wrap
                add     a, %1000                ; move to next third
                ld      h, a
                jr      drawFrog
testOKey:
                bit     2, d                    ; test O key
                jr      z, testPKey             ; if not pressed, test P key
                dec     hl                      ; move frog left (decrease hl by 1)
                jr      drawFrog
testPKey:
                bit     3, d                    ; test P key
                jr      z, scanKeysLoop         ; if not pressed, read keys again
                inc     hl                      ; move frog right (increase hl by 1)
                jr      drawFrog
drawFrog:
                ld      de, frog_up             ; up frog shape
                push    hl
                call    drwfrg                  ; draw frog routine
                pop     hl

                call    sleep_100ms
                jr      scanKeysLoop

exit:
                ret

;;;;;;; data area
                include "system_routines.asm"
                include "sprite_routines.asm"
                include "keyboard.asm"
                include "sprite_data.asm"
                include "chessboard.asm"

                ; Sleep for approximately 100 ms (assuming 3.5 MHz ZX Spectrum)
                ; 100 ms = 1/10th second, so about 350,000 cycles
                ; This is a rough delay loop, not frame-accurate

sleep_100ms:
                ld      bc, 5000                ; Adjust this value for timing accuracy
.sleep_loop:
                dec     bc
                ld      a, b
                or      c
                jr      nz, .sleep_loop
                ret

                end     $8000

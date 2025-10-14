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
                call    drwspr                  ; draw sprite routine
                pop     hl

scanKeysLoop:
                push    hl                      ; save original frog position
scanKeysLoopNoPush:
                call    ScanKeys                ; read keys pressed
testQKey:
                bit     0, d                    ; test Q key
                jr      z, testAKey             ; if not pressed, test A key
                ld      a, l                    ; move frog up
                sub     %100000                 ; move up one row
                ld      l, a
                jr      nc, testAKey            ; no need to change third
                ld      a, h                    ; handle third wrap
                sub     %1000                   ; move to previous third
                ld      h, a
testAKey:
                bit     1, d                    ; test A key
                jr      z, testOKey             ; if not pressed, test O key
                ld      a, l                    ; move frog down
                add     a, %100000              ; move down one row
                ld      l, a
                jr      nc, testOKey            ; no need to change third
                ld      a, h                    ; handle third wrap
                add     a, %1000                ; move to next third
                ld      h, a
testOKey:
                bit     2, d                    ; test O key
                jr      z, testPKey             ; if not pressed, test P key
                dec     hl                      ; move frog left (decrease hl by 1)
testPKey:
                bit     3, d                    ; test P key
                jr      z, testPositionChanged  ; if not pressed, go further
                inc     hl                      ; move frog right (increase hl by 1)

testPositionChanged:
                pop     de
                push    de
                ld      a, h
                cp      d
                jr      nz, moveFrog            ; if changed, move frog
                ld      a, l
                cp      e
                jr      z, scanKeysLoopNoPush   ; if not changed, read keys again

moveFrog:
                ex      (sp), hl                ; get original frog position, save new frog position on stack
                call    clrspr                  ; clear sprite routine
                pop     hl                      ; get new frog position

                ld      de, frog_up             ; up frog shape
                push    hl
                call    drwspr                  ; draw sprite routine
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
                include "time.asm"

                end     $8000

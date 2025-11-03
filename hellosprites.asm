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
                jr      z, testAKey             ; if not pressed, test another key
                ld      a, SCREEN_TOP           ; check upper boundary
                call    CheckTop
                jr      z, testAKey             ; if reached, skip moving up
                ld      a, l                    ; move frog up
                sub     %100000                 ; move up one row
                ld      l, a
                jr      nc, testAKey            ; no need to change third
                ld      a, h                    ; handle third wrap
                sub     %1000                   ; move to previous third
                ld      h, a
testAKey:
                bit     1, d                    ; test A key
                jr      z, testOKey             ; if not pressed, test another key
                ld      a, SCREEN_BOTTOM        ; check lower boundary
                call    CheckBottom
                jr      z, testOKey             ; if reached, skip moving down
                ld      a, l                    ; move frog down
                add     a, %100000              ; move down one row
                ld      l, a
                jr      nc, testOKey            ; no need to change third
                ld      a, h                    ; handle third wrap
                add     a, %1000                ; move to next third
                ld      h, a
testOKey:
                bit     2, d                    ; test O key
                jr      z, testPKey             ; if not pressed, test another key
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

; the frog sprite occupies 2x2 characters (16x16 pixels)
; the drwspr routine draws starting from bottom-left character so this character should be pointed by hl
; therefore the upper limit (SCREEN_TOP) should be set to second character row (row number 1)
; and the lower limit (SCREEN_BOTTOM) should be set to the last character row

;;;;;;;;;;;;;;;;;;;;;;;; TT$LLL$SSS
SCREEN_TOP      EQU     %00$001$000
SCREEN_BOTTOM   EQU     %10$111$000


                include "system_routines.asm"
                include "sprite_routines.asm"
                include "keyboard.asm"
                include "sprite_data.asm"
                include "chessboard.asm"
                include "time.asm"
                include "limits.asm"

                end     $8000

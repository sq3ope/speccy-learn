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
                ld      a, 4                    ; ink green
                ld      (frgink), a
                call    drwfrg                  ; draw frog routine

                call    wait_key                ; wait for key press

exit:
                ret

;;;;;;; data area
                include "system_routines.asm"
                include "sprite_routines.asm"
                include "keyboard.asm"
                include "sprite_data.asm"
                include "chessboard.asm"

                end     $8000

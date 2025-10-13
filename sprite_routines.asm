frgink          db      4                       ; ink colour

;--- draw frog shape routine
; hl = pos to draw frog shape
; de = ptr to frog shape
; variable frgink = ink color of frog shape
; uses af,bc,hl,de

drwfrg:
                ld      a, 2                    ; two row frog shape
                ex      af, af'
                push    hl                      ; store pos ptr
frglp0:
                push    hl
                ld      c, 2                    ; column count
drwfrg_draw_character:
                push    hl
                ld      b, 8                    ; will draw 8 lines of character

drwfrg_draw_line:
                ld      a, (de)                 ; get line of first char
                ld      (hl), a                 ; draw line of first char
                inc     de
                inc     h                       ; next line of the char
                djnz    drwfrg_draw_line

                pop     hl                      ; current destination pointer
                inc     hl                      ; move destination pointer to character to the right
                dec     c                       ; decr  column count
                jr      nz, drwfrg_draw_character

                pop     hl                      ; row ptr
                ex      af, af'
                dec     a                       ; dec lines of char
                ld      c, 32
                jr      z, frgatt               ; load frog attribute
                ex      af, af'
                and     a
                sbc     hl, bc                  ; move 32 char/1 line up
                bit     0, h                    ; test cross scr section
                jr      z, frglp0
                ld      a, h
                sub     7                       ; up one screen section
                ld      h, a
                jr      frglp0
frgatt:
                pop     hl                      ; pos ptr
                ld      a, h                    ; convert to attribute ptr
                and     $18
                sra     a
                sra     a
                sra     a
                add     a, $58
                ld      h, a

                push    de

                ld      a, (frgink)
                ld      d, a                    ; D = ink colour

                ld      a, (hl)
                and     %11111000               ; clear old ink
                or      d                       ; fill with new ink
                ld      (hl), a

                inc     hl                      ; next character

                ld      a, (hl)
                and     %11111000               ; clear old ink
                or      d                       ; fill with new ink
                ld      (hl), a

                sbc     hl, bc                  ; one line up

                ld      a, (hl)
                and     %11111000               ; clear old ink
                or      d                       ; fill with new ink
                ld      (hl), a

                dec     hl                      ; next char left

                ld      a, (hl)
                and     %11111000               ; clear old ink
                or      d                       ; fill with new ink
                ld      (hl), a

                pop     de

                ret

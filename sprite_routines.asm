sprink          db      4                       ; ink colour

;--- draw sprite shape routine
; hl = pos to draw sprite shape
; de = ptr to sprite shape
; variable sprink = ink color of sprite shape
; uses af,bc,hl,de

drwspr:
                ld      a, 2                    ; two row sprite shape
                ex      af, af'
                push    hl                      ; store pos ptr
sprlp0:
                push    hl
                ld      c, 2                    ; column count
drwspr_draw_character:
                push    hl
                ld      b, 8                    ; will draw 8 lines of character

drwspr_draw_line:
                ld      a, (de)                 ; get line of first char
                ld      (hl), a                 ; draw line of first char
                inc     de
                inc     h                       ; next line of the char
                djnz    drwspr_draw_line

                pop     hl                      ; current destination pointer
                inc     hl                      ; move destination pointer to character to the right
                dec     c                       ; decr  column count
                jr      nz, drwspr_draw_character

                pop     hl                      ; row ptr
                ex      af, af'
                dec     a                       ; dec lines of char
                ld      c, 32
                jr      z, spratt               ; load sprite attribute
                ex      af, af'
                and     a
                sbc     hl, bc                  ; subtract 100000b (32) to decrease line number bits
                bit     0, h                    ; test if we changed screen section (third)
                jr      z, sprlp0
                ld      a, h
                sub     7                       ; up one screen section
                ld      h, a
                jr      sprlp0
spratt:
                pop     hl                      ; pos ptr
                ld      a, h                    ; convert to attribute ptr
                and     $18
                sra     a
                sra     a
                sra     a
                add     a, $58
                ld      h, a

                push    de

                ld      a, (sprink)
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



;--- clear sprite shape routine
; hl = pos to draw sprite shape
; uses af,bc,hl

clrspr:
                ld      a, 2                    ; two row sprite shape
                ex      af, af'
csprlp0:
                push    hl
                ld      c, 2                    ; column count
clrspr_draw_character:
                push    hl
                ld      b, 8                    ; will draw 8 lines of character

                xor     a
clrspr_draw_line:
                ld      (hl), a                 ; draw line of first char
                inc     h                       ; next line of the char
                djnz    clrspr_draw_line

                pop     hl                      ; current destination pointer
                inc     hl                      ; move destination pointer to character to the right
                dec     c                       ; decr  column count
                jr      nz, clrspr_draw_character

                pop     hl                      ; row ptr
                ex      af, af'
                dec     a                       ; dec lines of char
                ld      c, 32
                ret     z                       ; done
                ex      af, af'
                and     a
                sbc     hl, bc                  ; subtract 100000b (32) to decrease line number bits
                bit     0, h                    ; test if we changed screen section (third)
                jr      z, csprlp0
                ld      a, h
                sub     7                       ; up one screen section
                ld      h, a
                jr      csprlp0

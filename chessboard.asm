cb_white_attr   equ     7 * 8 + 64              ; backgroundcolour bright white
cb_black_attr   equ     0 * 8 + 64              ; backgroundcolour 0 = black

draw_chessboard:
                ld      hl, $5800               ; HL = start of screen attributes memory
                ld      b, 24                   ; B = 24 rows
                ld      a, cb_black_attr        ; initial square colour

chessboard_row_loop:
                push    bc
                ld      b, 32                   ; B = 32 columns
                call    flip_square_colour      ; flip square colour

chessboard_column_loop:
                call    flip_square_colour      ; flip square colour
                ld      (hl), a                 ; draw square
                inc     hl
                djnz    chessboard_column_loop

                pop     bc
                djnz    chessboard_row_loop
                ret

flip_square_colour:
                ld      c, cb_black_attr        ; C = black square
                cp      c                       ; is it black square?
                jr      z, select_white
                ld      a, cb_black_attr        ; A = black square
                ret
select_white:
                ld      a, cb_white_attr        ; A = white square
                ret

;--------------------------------------------------------------------
; Evaluates whether the lower limit has been reached.
; Input:  A  -> Upper limit (TTLLLLSSS).
;         HL -> Current position (010TTSSS LLLCCCCCCC).
; Output: Z  =  Reached.
;         NZ =  Not reached.
;
; Alters the value of the AF and BC registers.
;--------------------------------------------------------------------
CheckBottom:
call            checkVerticalLimit              ; Compare current position with limit
                                                ; If Z or NC has reached the ceiling, Z is set, otherwise NZ is set.
ret             c
checkBottom_bottom:
xor             a                               ; Activate Z
ret

;--------------------------------------------------------------------
; Evaluates whether the upper limit has been reached.
; Input:  A  -> Upper margin (TTLLLLSSS).
;         HL -> Current position (010TTSSS LLLCCCCCCC).
; Output: Z  =  Reached.
;         NZ =  Not reached.
;
; Alters the value of the AF and BC registers.
;--------------------------------------------------------------------
CheckTop:
call            checkVerticalLimit              ; Compare current position with limit
ret                                             ; checkVerticalLimit is enough

;--------------------------------------------------------------------
; Evaluates whether the vertical limit has been reached.
; Input: A  -> Vertical limit (TTLLLLSSS).
;        HL -> Current position (010TTSSS LLLCCCCC).
;
; Alters the value of the AF and BC registers.
;--------------------------------------------------------------------
checkVerticalLimit:
ld              b,      a                       ; Stores the value of A in B
ld              a,      h                       ; A = value of H (010TTSSSSSS)
and             $18                             ; Keeps the third
rlca
rlca
rlca                                            ; Sets the value of the third in bits 6 and 7
ld              c,      a                       ; Load the value in C
ld              a,      h                       ; A = value of H (010TTSSSSSS)
and             $07                             ; Keeps the scanline
or              c                               ; Add the third
ld              c,      a                       ; Load the value in C
ld              a,      l                       ; A = value of L (LLLCCCCCCC)
and             $e0                             ; Keeps the line
rrca
rrca                                            ; Puts the line on bits 3, 4 and 5
or              c                               ; Adds third and scanline. A = CCCCCCC
cp              b                               ; Compare with B = original value A = boundary
ret

;--------------------------------------------------------------------
; Evaluates whether the left limit has been reached.
; Input:  A  -> Left limit (00CCCCC).
;         HL -> Current position (010TTSSS LLLCCCCCCC).
; Output: Z  =  Reached.
;         NZ =  Not reached.
;
; Alters the value of the AF and BC registers.
;--------------------------------------------------------------------
CheckLeft:
call            checkHorizontalLimit            ; Compare current position with limit
ret                                             ; checkHorizontalLimit is enough

;--------------------------------------------------------------------
; Evaluates whether the right limit has been reached.
; Input:  A  -> Right limit (00CCCCC).
;         HL -> Current position (010TTSSS LLLCCCCCCC).
; Output: Z  =  Reached.
;         NZ =  Not reached.
;
; Alters the value of the AF and BC registers.
;--------------------------------------------------------------------
CheckRight:
call            checkHorizontalLimit            ; Compare current position with limit
                                                ; If Z or NC has reached the ceiling, Z is set, otherwise NZ is set.
ret             c
checkRight_bottom:
xor             a                               ; Activate Z
ret

;--------------------------------------------------------------------
; Evaluates whether the horizontal limit has been reached.
; Input: A  -> Horizontal limit (000CCCCC).
;        HL -> Current position (010TTSSS LLLCCCCC).
;
; Alters the value of the AF and BC registers.
;--------------------------------------------------------------------
checkHorizontalLimit:
ld              b,      a                       ; Stores the value of A in B
ld              a,      l                       ; A = value of L (LLLCCCCC)
and             %00011111                       ; Keeps the columns
cp              b                               ; Compare with B = original value A = boundary
ret

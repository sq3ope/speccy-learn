; System variable: permanent display attributes.
; Format: FLASH, BRIGHT, PAPER, INK (FBPPPIII).
ATTR_S          equ     $5c8d

; System variable: current attribute (FBPPPIII).
ATTR_T          equ     $5c8f

;--------------------------------------------------------------------
; ROM Routine similar to Basic AT
; Position the cursor at the specified coordinates.
; Input: B -> Y-coordinate.
;        C -> X-coordinate.
; In this routine, the top left-hand corner of the screen
; it is (24, 33).
; Alters the value of the A, DE and HL registers.
; -------------------------------------------------------------------
LOCATE          equ     $0dd9

; -------------------------------------------------------------------
; ROM routine similar to Basic's CLS.
; Clears the display using the attributes loaded in the
; system variable ATTR_S.
; Alters the value of the AF, BC, DE and HL registers.
; -------------------------------------------------------------------
CLS             equ     $0daf

		org $8000
		
		ld a, $00 		; A = colour attributes
		ld hl, ATTR_T 	; HL = address current attributes
		ld (hl), a 		; Load into memory
		ld hl, ATTR_S 	; HL = address permanent attributes
		ld (hl), a 		; Load into memory
		
		call CLS 		; Clear screen: use ATTR_S
		out ($fe), a 	; Change border colour
		
;;;;;;;;;;;;;;;;010$TT$SSS$LLL$CCCCC
		ld hl, %010$01$000$100$10000 ; screen memory first char in second third
		
		ld de, frog_up 	; up frog shape
		ld a, 4 		; (paper 0) * 8 + (ink 4)
		ld (attr), a
		
;push    bc
;push    de
;push    hl
		
		call drwfrg 	; draw frog routine
		call wait_key 	; wait for key press
		
exit:	
		ret
		
        ; data area
		include "system_routines.asm"
		include "sprite_routines.asm"
        include "keyboard.asm"
        include "sprite_data.asm"

		end $8000

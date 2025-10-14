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

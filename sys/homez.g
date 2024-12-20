; homez.g
; called to home the Z axis

G91
; Trinamic tuning
G1 H2 Z0.0000625        ; 1 microstep movement to energize steppers
G4 P150                 ; pause for <130ms

G1 Z5 F800 H2			; lift Z relative to current position
G90						; absolute positioning
G1 X150 Y150 F6000		; go to first probe point
G30						; home Z by probing the bed
G1 Z5 F200				; lift Z a little off the bed
G90


; homez.g
; called to home the Z axis
; generated by RepRapFirmware Configuration Tool v3.1.3 on Sat Jun 13 2020 15:20:34 GMT-0500 (Central Daylight Time)
;
;M561                    ; clear bed transform
;G91                     ; relative positioning
;
; Trinamic tuning
;G1 H2 Z0.0005           ; just enough movement to energize steppers
;G4 P150                 ; pause for 150ms
;
;G1 H2 Z5 F6000          ; lift Z relative to current position
;G90                     ; absolute positioning
;G1 X{ 102.7 - sensors.probes[0].offsets[0] } Y{ 81.5- sensors.probes[0].offsets[1] } F99999  ; go to first probe point
;G30                     ; home Z by probing the bed
;G1 X10 Y10 F99999       ; return the carriage to the corner
;G1 Z5 F300              ; lift Z a little off the bed
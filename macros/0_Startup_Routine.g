; Startup routine
; Home, true-level, and re-home Z with a single Euclid pickup/drop-off cycle

;M280 P0 S160		; Reset BLTouch
;M280 P0 S120		; BLTouch Self Test
G29 S2				; Unloads Mesh Map
G28 X Y				; Home XY before travelling to the probe dock
M401				; Pick up the Euclid probe once
G28 Z				; Establish Z before levelling
G32				; True-level the bed while keeping the probe deployed
G28 Z				; Re-home Z after levelling
M402				; Return the Euclid probe once
G1 X-37 Y150 F3000	; move to purge bucket
G29 S1				; Load Mesh Map

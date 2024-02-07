; Startup Routing
; Homes all axes and true levels the bed for that sweet first layer goodness

;M280 P0 S160		; Reset BLTouch
;M280 P0 S120		; BLTouch Self Test
G29 S2				; Unloads Mesh Map
G28				; Homes all axes
G32				; True Level 1
;G28	Z			; Home Z
;G32				; True Level 2 just to be sure
;G28 Z				; Home Z
G1 X-37 Y150 F3000	; move to purge bucket
G29 S1				; Load Mesh Map

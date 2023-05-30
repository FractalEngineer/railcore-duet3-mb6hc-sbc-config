;unload PLA
T0
G10 S195 		; Heat up the current tool to 195C enough for PLA
M116 			; Wait for the temperatures to be reached
G1 F200 E5 		; prime extruder 5mm
G1 E-45 F2000	; yeet out 45 mm
M400 			; Wait for the moves to finish
M84 E0 			; Turn off extruder drives 1 and 2
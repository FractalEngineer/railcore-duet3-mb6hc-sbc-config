; Pause macro file
M83					; relative extruder moves
G1 E-2 F2500		; retract 2mm
G91					; relative moves
if move.axes[2].machinePosition + 5 < move.axes[2].max
    G1 H2 Z5 F5000			; raise nozzle 5mm
else
    G1 H2 Z{move.axes[2].max - move.axes[2].machinePosition} F5000
G90					; absolute moves
G1 X25 Y25 F5000	; move head out of the way of the print

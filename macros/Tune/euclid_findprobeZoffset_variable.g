;***
; findZprobeoffset.g
; ***
; the system must be homed before running this macro

; make sure that the nozzle is properly gapped with known height gauge before the start of the test
; Preheat nozzle to 130, clean nozzle, touch off nozzle to 0.2mm feeler gauge, G92 Z0.2

var shimThickness = 0.2
M291 R"WARNING" P"What are you probing against? It will be probed 10 times and return mean and standard deviation." S4 K{"0mm (direct contact)","0.1mm Paper","0.2mm Feeler Gauge"}
; input = 0, 1 or 2 depending on which button was pressed
if input == 0
    set var.shimThickness = 0
elif input == 1
    set var.shimThickness = 0.1
else
    set var.shimThickness = 0.2

G92 Z{var.shimThickness}   ; to define that height as Z=shim thickness
M401                 ; deploy probe
G1 X150 Y150 Z15     ; travel to X,Y of probe point 15mm above bed

; RRF only auto-lifts between taps when G30 is given P/X/Y coords (bed.g style).
; A bare "G30 Z-9999" probes from the CURRENT height, so without lifting first,
; every probe after the first starts already in contact with the gauge and
; RRF errors "probe already triggered before probing move started".
; Fix: retract a few mm before each repeat probe.

G30 Z-9999           ; probe point 1
G91
G1 Z5 F600           ; lift clear of the gauge before next probe
G90
G30 Z-9999           ; probe point 2
G91
G1 Z5 F600
G90
G30 Z-9999           ; probe point 3
G91
G1 Z5 F600
G90
G30 Z-9999           ; probe point 4
G91
G1 Z5 F600
G90
G30 Z-9999           ; probe point 5
G91
G1 Z5 F600
G90
G30 Z-9999           ; probe point 6
G91
G1 Z5 F600
G90
G30 Z-9999           ; probe point 7
G91
G1 Z5 F600
G90
G30 Z-9999           ; probe point 8
G91
G1 Z5 F600
G90
G30 Z-9999           ; probe point 9
G91
G1 Z5 F600
G90
G30 Z-9999 S-1       ; probe point 10, compute average and standard deviation
G91
G1 Z5 F600           ; lift clear before the final trigger-height probe
G90
G30 S-3              ; probe the bed without resetting Z=0, report to console

G91
G1 Z15
G90
M402                 ; retract probe
M500 P31             ; save G31 information to sys/config-override.g

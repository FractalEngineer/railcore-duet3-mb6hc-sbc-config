;***  
; findZprobeoffset.g  
; ***  
; the system must be homed before running this macro

; make sure that the nozzle is properly gapped with known height gauge before the start of the test
; Preheat nozzle to 130, clean nozzle, touch off nozzle to 0.2mm feeler gauge, G92 Z0.2 

M291 P"Is the nozzle probing a 0.2mm feeler gauge? Probe will be tested 10 times and return mean and standard deviation. Ok or Cancel?" R"WARNING" S3  
; User must click OK or cancel.  

G92 Z0.2             ; to define that height as Z=0.2
M401               ; deploy probe
G1 X150 Y150 Z15   ; travel to X,Y of probe point 15mm above bed  
;G30 Z-9999         ; probe point 1
;G30 Z-9999         ; probe point 2
;G30 Z-9999         ; probe point 3
;G30 Z-9999         ; probe point 4
;G30 Z-9999         ; probe point 5
;G30 Z-9999         ; probe point 6
;G30 Z-9999         ; probe point 7
;G30 Z-9999         ; probe point 8
;G30 Z-9999         ; probe point 9
;G30 Z-9999 S-1     ; probe point 10, computer average and standard of deviation
G30 S-3             ; Probes the bed without resetting the Z=0 position and reports to the G-code console.
G91
G0 Z15
G90
M402               ; retract probe
M500 P31            ; Save G31 information to sys/config-override.g on the SD card
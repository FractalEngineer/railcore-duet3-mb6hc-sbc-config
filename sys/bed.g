M561 						; clear any existing bed transform
echo "DEBUG: Call deployprobe.g macro" 
M401 P0                                         ; This runs macro file deployprobe
echo "DEBUG: returned from deployprobe.g"

G1 Z5	H2
G30 P0 X30 Y5 Z-99999
G30 P1 X30 Y305 Z-99999
G30 P2 X295 Y305 Z-99999 
G30 P3 X295 Y5 Z-99999 S3

echo "DEBUG: Call retractprobe.g macro"
M402 P0                                         ; retract / remove probe
echo "DEBUG: Returned from retractprobe.g"

G1 X-30 Y150 F6000               ; move the head to purge bucket
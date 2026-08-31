; Keep a probe deployed by the caller attached. This lets the startup routine
; perform G28 Z, G32, and G28 Z with one Euclid pickup/drop-off cycle while
; preserving normal standalone G32 behaviour.
var probeAlreadyDeployed = sensors.probes[0].deployedByUser

M561 						; clear any existing bed transform
if !var.probeAlreadyDeployed
	echo "DEBUG: Call deployprobe.g macro"
	M401 P0                                     ; This runs macro file deployprobe
	echo "DEBUG: returned from deployprobe.g"

G1 Z5	H2
G30 P0 X30 Y5 Z-99999
G30 P1 X30 Y305 Z-99999
G30 P2 X295 Y305 Z-99999
G30 P3 X295 Y5 Z-99999 S3

if !var.probeAlreadyDeployed
	echo "DEBUG: Call retractprobe.g macro"
	M402 P0                                     ; retract / remove probe
	echo "DEBUG: Returned from retractprobe.g"
	G1 X-30 Y150 F6000                          ; move the head to purge bucket

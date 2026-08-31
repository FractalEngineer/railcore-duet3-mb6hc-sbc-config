; Calibrate the Euclid probe trigger height (G31 Z)
;
; Before running this macro:
; 1. Home the printer and retract the probe.
; 2. Heat and clean the nozzle.
; 3. Place a known shim on the bed and jog the nozzle down until it just grips it.
; 4. Leave the nozzle at that position and run this macro.
;
; The nozzle position establishes the physical Z datum. The macro probes the same
; physical XY location 10 times, averages the measured stop heights, sets G31 Z
; to that mean, and saves G31 to sys/config-override.g.

if !move.axes[0].homed || !move.axes[1].homed || !move.axes[2].homed
    abort "Home all axes before calibrating the probe trigger height"

M400

; Save the physical point currently under the nozzle. To measure that same point
; with the probe, subtract the configured probe offset from the nozzle position.
var nozzleX = move.axes[0].userPosition
var nozzleY = move.axes[1].userPosition
var probeX = var.nozzleX - sensors.probes[0].offsets[0]
var probeY = var.nozzleY - sensors.probes[0].offsets[1]

if var.probeX < move.axes[0].min || var.probeX > move.axes[0].max || var.probeY < move.axes[1].min || var.probeY > move.axes[1].max
    abort "Move the nozzle farther from the bed edge before calibrating"

var shimThickness = 0.2
M291 R"Select calibration shim" P"Confirm that the clean nozzle is already gripping this shim at the current XY position." S4 K{"0mm (direct contact)","0.1mm Paper","0.2mm Feeler Gauge"}
if input == 0
    set var.shimThickness = 0.0
elif input == 1
    set var.shimThickness = 0.1
else
    set var.shimThickness = 0.2

; Remove transforms before using the nozzle position as the physical datum.
G29 S2
M561
G92 Z{var.shimThickness}

M401 P0
G1 X{var.probeX} Y{var.probeY} Z15 F6000

var sampleCount = 10
var sample = 0
var reading = 0.0
var total = 0.0
var minimum = 999.0
var maximum = -999.0

; S-1 reports the stop height without changing the Z coordinate. This preserves
; the nozzle datum established above instead of feeding the old G31 value back
; into the calibration.
while var.sample < var.sampleCount
    G30 K0 S-1
    set var.reading = sensors.probes[0].lastStopHeight
    set var.total = var.total + var.reading
    if var.reading < var.minimum
        set var.minimum = var.reading
    if var.reading > var.maximum
        set var.maximum = var.reading
    set var.sample = var.sample + 1
    if var.sample < var.sampleCount
        G91
        G1 Z5 F600
        G90

var mean = var.total / var.sampleCount
G31 K0 Z{var.mean}

G91
G1 Z15 F600
G90
M402 P0

M500 P31
echo "Z probe trigger height set to " ^ var.mean ^ " mm; 10-sample range " ^ var.minimum ^ " to " ^ var.maximum ^ " mm"

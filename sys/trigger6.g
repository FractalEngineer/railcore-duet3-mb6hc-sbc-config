; /sys/trigger6.g
; Black button when not processing a print
; Function: resume only when a print is paused

if state.status == "paused"
    M24
else
    echo "Resume ignored because no print is paused"

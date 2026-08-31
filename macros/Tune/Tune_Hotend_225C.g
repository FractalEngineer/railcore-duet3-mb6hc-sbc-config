; Tune tool 0's primary heater at 225C using full heater power.
; F0.7 models the print-cooling fan at 70% during the asynchronous tune.
M291 P"Starting T0/H1 auto-tune at 225C. Monitor the heater state and wait for tuning to finish." R"Tune T0/H1 at 225C" S0 T10
M303 T0 P1 S225 F0.7
M291 P"Auto-tune started. When RRF reports completion, run Tune_Hotend_Save_Results." R"Tune T0/H1 at 225C" S0 T10

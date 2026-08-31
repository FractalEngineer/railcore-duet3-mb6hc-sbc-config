; Tune tool 0's primary heater at 215C using full heater power.
; F0.7 models the print-cooling fan at 70% during the asynchronous tune.
M291 P"Starting T0/H1 auto-tune at 215C. Monitor the heater state and wait for tuning to finish." R"Tune T0/H1 at 215C" S0 T10
M303 T0 P1 S215 F0.7
M291 P"Auto-tune started. When RRF reports completion, run Tune_Hotend_Save_Results." R"Tune T0/H1 at 215C" S0 T10



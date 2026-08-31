; Tune tool 0's primary heater at 260C using full heater power.
; F0.7 models the print-cooling fan at 70% during the asynchronous tune.
M291 P"Starting T0/H1 auto-tune at 260C. Monitor the heater state and wait for tuning to finish." R"Tune T0/H1 at 260C" S0 T10
M303 T0 P1 S260 F0.7
M291 P"Auto-tune started. When RRF reports completion, run Tune_Hotend_Save_Results." R"Tune T0/H1 at 260C" S0 T10


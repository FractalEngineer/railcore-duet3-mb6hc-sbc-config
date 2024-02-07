; ### Marlin K-Factor Calibration Pattern ###
; -------------------------------------------
;
; Printer: Railcore
; Filament: TPU
; Created: Mon Aug 08 2022 23:40:47 GMT+0800 (Taipei Standard Time)
;
; Settings Printer:
; Filament Diameter = 1.75 mm
; Nozzle Diameter = 0.5 mm
; Nozzle Temperature = 215 °C
; Bed Temperature = 0 °C
; Retraction Distance = 0.4 mm
; Layer Height = 0.3 mm
; Extruder = 0 
; Fan Speed = 0 %
; Z-axis Offset = 0 mm
;
; Settings Print Bed:
; Bed Shape = Rect
; Bed Size X = 200 mm
; Bed Size Y = 200 mm
; Origin Bed Center = false
;
; Settings Speed:
; Slow Printing Speed = 900 mm/min
; Fast Printing Speed = 4800 mm/min
; Movement Speed = 12000 mm/min
; Retract Speed = 1800 mm/min
; Unretract Speed = 1800 mm/min
; Printing Acceleration = 800 mm/s^2
; Jerk X-axis =  firmware default
; Jerk Y-axis =  firmware default
; Jerk Z-axis =  firmware default
; Jerk Extruder =  firmware default
;
; Settings Pattern:
; Linear Advance Version = 1.5
; Starting Value Factor = 0
; Ending Value Factor = 1
; Factor Stepping = 0.05
; Test Line Spacing = 5 mm
; Test Line Length Slow = 20 mm
; Test Line Length Fast = 40 mm
; Print Pattern = Standard
; Print Frame = true
; Number Lines = true
; Print Size X = 98 mm
; Print Size Y = 125 mm
; Print Rotation = 0 degree
;
; Settings Advance:
; Nozzle / Line Ratio = 1.05
; Bed leveling = 0
; Use FWRETRACT = false
; Extrusion Multiplier = 1
; Prime Nozzle = true
; Prime Extrusion Multiplier = 2.5
; Prime Speed = 1800
; Dwell Time = 2 s
;
; prepare printing
;
G21 ; Millimeter units
G90 ; Absolute XYZ
M83 ; Relative E
T0 ; Switch to tool 0
M104 S215 ; Set nozzle temperature (no wait)
M190 S0 ; Set bed temperature (wait)
;G28 ; Home all axes
G1 Z5 F100 ; Z raise
M109 S215 ; Wait for nozzle temp
M204 P800 ; Acceleration
G92 E0 ; Reset extruder distance
M106 P0 S0
G1 X100 Y100 F12000 ; move to start
G1 Z0.3 F900 ; Move to layer height
;
; prime nozzle
;
G1 X51 Y37.5 F12000 ; move to start
G1 X51 Y162.5 E20.4628 F1800 ; print line
G1 X51.7875 Y162.5 F12000 ; move to start
G1 X51.7875 Y37.5 E20.4628 F1800 ; print line
G1 E-0.4 F1800 ; retract
;
; print anchor frame
;
G1 X61 Y34.5 F12000 ; move to start
G1 E0.4 F1800 ; un-retract
G1 X61 Y140.5 E7.6351 F900 ; print line
G1 X61.525 Y140.5 F12000 ; move to start
G1 X61.525 Y34.5 E7.6351 F900 ; print line
G1 E-0.4 F1800 ; retract
G1 X141 Y34.5 F12000 ; move to start
G1 E0.4 F1800 ; un-retract
G1 X141 Y140.5 E7.6351 F900 ; print line
G1 X140.475 Y140.5 F12000 ; move to start
G1 X140.475 Y34.5 E7.6351 F900 ; print line
G1 E-0.4 F1800 ; retract
;
; start the Test pattern
;
G4 P2000 ; Pause (dwell) for 2 seconds
G1 X61 Y37.5 F12000 ; move to start
M900 K0 ; set K-factor
M572 D0 S0 ; 
G1 E0.4 F1800 ; un-retract
G1 X81 Y37.5 E1.3096 F900 ; print line
G1 X121 Y37.5 E2.6192 F4800 ; print line
G1 X141 Y37.5 E1.3096 F900 ; print line
G1 E-0.4 F1800 ; retract
G1 X61 Y42.5 F12000 ; move to start
M900 K0.05 ; set K-factor
M572 D0 S0.05 ; 
G1 E0.4 F1800 ; un-retract
G1 X81 Y42.5 E1.3096 F900 ; print line
G1 X121 Y42.5 E2.6192 F4800 ; print line
G1 X141 Y42.5 E1.3096 F900 ; print line
G1 E-0.4 F1800 ; retract
G1 X61 Y47.5 F12000 ; move to start
M900 K0.1 ; set K-factor
M572 D0 S0.1 ; 
G1 E0.4 F1800 ; un-retract
G1 X81 Y47.5 E1.3096 F900 ; print line
G1 X121 Y47.5 E2.6192 F4800 ; print line
G1 X141 Y47.5 E1.3096 F900 ; print line
G1 E-0.4 F1800 ; retract
G1 X61 Y52.5 F12000 ; move to start
M900 K0.15 ; set K-factor
M572 D0 S0.15 ; 
G1 E0.4 F1800 ; un-retract
G1 X81 Y52.5 E1.3096 F900 ; print line
G1 X121 Y52.5 E2.6192 F4800 ; print line
G1 X141 Y52.5 E1.3096 F900 ; print line
G1 E-0.4 F1800 ; retract
G1 X61 Y57.5 F12000 ; move to start
M900 K0.2 ; set K-factor
M572 D0 S0.2 ; 
G1 E0.4 F1800 ; un-retract
G1 X81 Y57.5 E1.3096 F900 ; print line
G1 X121 Y57.5 E2.6192 F4800 ; print line
G1 X141 Y57.5 E1.3096 F900 ; print line
G1 E-0.4 F1800 ; retract
G1 X61 Y62.5 F12000 ; move to start
M900 K0.25 ; set K-factor
M572 D0 S0.25 ; 
G1 E0.4 F1800 ; un-retract
G1 X81 Y62.5 E1.3096 F900 ; print line
G1 X121 Y62.5 E2.6192 F4800 ; print line
G1 X141 Y62.5 E1.3096 F900 ; print line
G1 E-0.4 F1800 ; retract
G1 X61 Y67.5 F12000 ; move to start
M900 K0.3 ; set K-factor
M572 D0 S0.3 ; 
G1 E0.4 F1800 ; un-retract
G1 X81 Y67.5 E1.3096 F900 ; print line
G1 X121 Y67.5 E2.6192 F4800 ; print line
G1 X141 Y67.5 E1.3096 F900 ; print line
G1 E-0.4 F1800 ; retract
G1 X61 Y72.5 F12000 ; move to start
M900 K0.35 ; set K-factor
M572 D0 S0.35 ; 
G1 E0.4 F1800 ; un-retract
G1 X81 Y72.5 E1.3096 F900 ; print line
G1 X121 Y72.5 E2.6192 F4800 ; print line
G1 X141 Y72.5 E1.3096 F900 ; print line
G1 E-0.4 F1800 ; retract
G1 X61 Y77.5 F12000 ; move to start
M900 K0.4 ; set K-factor
M572 D0 S0.4 ; 
G1 E0.4 F1800 ; un-retract
G1 X81 Y77.5 E1.3096 F900 ; print line
G1 X121 Y77.5 E2.6192 F4800 ; print line
G1 X141 Y77.5 E1.3096 F900 ; print line
G1 E-0.4 F1800 ; retract
G1 X61 Y82.5 F12000 ; move to start
M900 K0.45 ; set K-factor
M572 D0 S0.45 ; 
G1 E0.4 F1800 ; un-retract
G1 X81 Y82.5 E1.3096 F900 ; print line
G1 X121 Y82.5 E2.6192 F4800 ; print line
G1 X141 Y82.5 E1.3096 F900 ; print line
G1 E-0.4 F1800 ; retract
G1 X61 Y87.5 F12000 ; move to start
M900 K0.5 ; set K-factor
M572 D0 S0.5 ; 
G1 E0.4 F1800 ; un-retract
G1 X81 Y87.5 E1.3096 F900 ; print line
G1 X121 Y87.5 E2.6192 F4800 ; print line
G1 X141 Y87.5 E1.3096 F900 ; print line
G1 E-0.4 F1800 ; retract
G1 X61 Y92.5 F12000 ; move to start
M900 K0.55 ; set K-factor
M572 D0 S0.55 ; 
G1 E0.4 F1800 ; un-retract
G1 X81 Y92.5 E1.3096 F900 ; print line
G1 X121 Y92.5 E2.6192 F4800 ; print line
G1 X141 Y92.5 E1.3096 F900 ; print line
G1 E-0.4 F1800 ; retract
G1 X61 Y97.5 F12000 ; move to start
M900 K0.6 ; set K-factor
M572 D0 S0.6 ; 
G1 E0.4 F1800 ; un-retract
G1 X81 Y97.5 E1.3096 F900 ; print line
G1 X121 Y97.5 E2.6192 F4800 ; print line
G1 X141 Y97.5 E1.3096 F900 ; print line
G1 E-0.4 F1800 ; retract
G1 X61 Y102.5 F12000 ; move to start
M900 K0.65 ; set K-factor
M572 D0 S0.65 ; 
G1 E0.4 F1800 ; un-retract
G1 X81 Y102.5 E1.3096 F900 ; print line
G1 X121 Y102.5 E2.6192 F4800 ; print line
G1 X141 Y102.5 E1.3096 F900 ; print line
G1 E-0.4 F1800 ; retract
G1 X61 Y107.5 F12000 ; move to start
M900 K0.7 ; set K-factor
M572 D0 S0.7 ; 
G1 E0.4 F1800 ; un-retract
G1 X81 Y107.5 E1.3096 F900 ; print line
G1 X121 Y107.5 E2.6192 F4800 ; print line
G1 X141 Y107.5 E1.3096 F900 ; print line
G1 E-0.4 F1800 ; retract
G1 X61 Y112.5 F12000 ; move to start
M900 K0.75 ; set K-factor
M572 D0 S0.75 ; 
G1 E0.4 F1800 ; un-retract
G1 X81 Y112.5 E1.3096 F900 ; print line
G1 X121 Y112.5 E2.6192 F4800 ; print line
G1 X141 Y112.5 E1.3096 F900 ; print line
G1 E-0.4 F1800 ; retract
G1 X61 Y117.5 F12000 ; move to start
M900 K0.8 ; set K-factor
M572 D0 S0.8 ; 
G1 E0.4 F1800 ; un-retract
G1 X81 Y117.5 E1.3096 F900 ; print line
G1 X121 Y117.5 E2.6192 F4800 ; print line
G1 X141 Y117.5 E1.3096 F900 ; print line
G1 E-0.4 F1800 ; retract
G1 X61 Y122.5 F12000 ; move to start
M900 K0.85 ; set K-factor
M572 D0 S0.85 ; 
G1 E0.4 F1800 ; un-retract
G1 X81 Y122.5 E1.3096 F900 ; print line
G1 X121 Y122.5 E2.6192 F4800 ; print line
G1 X141 Y122.5 E1.3096 F900 ; print line
G1 E-0.4 F1800 ; retract
G1 X61 Y127.5 F12000 ; move to start
M900 K0.9 ; set K-factor
M572 D0 S0.9 ; 
G1 E0.4 F1800 ; un-retract
G1 X81 Y127.5 E1.3096 F900 ; print line
G1 X121 Y127.5 E2.6192 F4800 ; print line
G1 X141 Y127.5 E1.3096 F900 ; print line
G1 E-0.4 F1800 ; retract
G1 X61 Y132.5 F12000 ; move to start
M900 K0.95 ; set K-factor
M572 D0 S0.95 ; 
G1 E0.4 F1800 ; un-retract
G1 X81 Y132.5 E1.3096 F900 ; print line
G1 X121 Y132.5 E2.6192 F4800 ; print line
G1 X141 Y132.5 E1.3096 F900 ; print line
G1 E-0.4 F1800 ; retract
G1 X61 Y137.5 F12000 ; move to start
;
; Mark the test area for reference
M572 D0 S0
M900 K0 ; Set K-factor 0
G1 X81 Y142.5 F12000 ; move to start
G1 E0.4 F1800 ; un-retract
G1 X81 Y162.5 E1.3096 F900 ; print line
G1 E-0.4 F1800 ; retract
G1 X121 Y142.5 F12000 ; move to start
G1 E0.4 F1800 ; un-retract
G1 X121 Y162.5 E1.3096 F900 ; print line
G1 E-0.4 F1800 ; retract
G1 Z0.4 F900 ; zHop
;
; print K-values
;
G1 X143 Y35.5 F12000 ; move to start
G1 Z0.3 F900 ; zHop
G1 E0.4 F1800 ; un-retract
G1 X145 Y35.5 E0.131 F900 ; 0
G1 X145 Y37.5 E0.131 F900 ; 0
G1 X145 Y39.5 E0.131 F900 ; 0
G1 X143 Y39.5 E0.131 F900 ; 0
G1 X143 Y37.5 E0.131 F900 ; 0
G1 X143 Y35.5 E0.131 F900 ; 0
G1 E-0.4 F1800 ; retract
G1 Z0.4 F900 ; zHop
G1 X143 Y45.5 F12000 ; move to start
G1 Z0.3 F900 ; zHop
G1 E0.4 F1800 ; un-retract
G1 X145 Y45.5 E0.131 F900 ; 0
G1 X145 Y47.5 E0.131 F900 ; 0
G1 X145 Y49.5 E0.131 F900 ; 0
G1 X143 Y49.5 E0.131 F900 ; 0
G1 X143 Y47.5 E0.131 F900 ; 0
G1 X143 Y45.5 E0.131 F900 ; 0
G1 E-0.4 F1800 ; retract
G1 X146 Y45.5 F12000 ; move to start
G1 E0.4 F1800 ; un-retract
G1 X146 Y45.9 E0.0262 F900 ; dot
G1 E-0.4 F1800 ; retract
G1 X147 Y45.5 F12000 ; move to start
G1 E0.4 F1800 ; un-retract
G1 X147 Y47.5 E0.131 F900 ; 1
G1 X147 Y49.5 E0.131 F900 ; 1
G1 E-0.4 F1800 ; retract
G1 Z0.4 F900 ; zHop
G1 X143 Y55.5 F12000 ; move to start
G1 Z0.3 F900 ; zHop
G1 E0.4 F1800 ; un-retract
G1 X145 Y55.5 E0.131 F900 ; 0
G1 X145 Y57.5 E0.131 F900 ; 0
G1 X145 Y59.5 E0.131 F900 ; 0
G1 X143 Y59.5 E0.131 F900 ; 0
G1 X143 Y57.5 E0.131 F900 ; 0
G1 X143 Y55.5 E0.131 F900 ; 0
G1 E-0.4 F1800 ; retract
G1 X146 Y55.5 F12000 ; move to start
G1 E0.4 F1800 ; un-retract
G1 X146 Y55.9 E0.0262 F900 ; dot
G1 E-0.4 F1800 ; retract
G1 X147 Y55.5 F12000 ; move to start
G1 E0.4 F1800 ; un-retract
G1 X147 Y57.5 F12000 ; move to start
G1 X147 Y59.5 F12000 ; move to start
G1 X149 Y59.5 E0.131 F900 ; 2
G1 X149 Y57.5 E0.131 F900 ; 2
G1 X147 Y57.5 E0.131 F900 ; 2
G1 X147 Y55.5 E0.131 F900 ; 2
G1 X149 Y55.5 E0.131 F900 ; 2
G1 E-0.4 F1800 ; retract
G1 Z0.4 F900 ; zHop
G1 X143 Y65.5 F12000 ; move to start
G1 Z0.3 F900 ; zHop
G1 E0.4 F1800 ; un-retract
G1 X145 Y65.5 E0.131 F900 ; 0
G1 X145 Y67.5 E0.131 F900 ; 0
G1 X145 Y69.5 E0.131 F900 ; 0
G1 X143 Y69.5 E0.131 F900 ; 0
G1 X143 Y67.5 E0.131 F900 ; 0
G1 X143 Y65.5 E0.131 F900 ; 0
G1 E-0.4 F1800 ; retract
G1 X146 Y65.5 F12000 ; move to start
G1 E0.4 F1800 ; un-retract
G1 X146 Y65.9 E0.0262 F900 ; dot
G1 E-0.4 F1800 ; retract
G1 X147 Y65.5 F12000 ; move to start
G1 E0.4 F1800 ; un-retract
G1 X147 Y67.5 F12000 ; move to start
G1 X147 Y69.5 F12000 ; move to start
G1 X149 Y69.5 E0.131 F900 ; 3
G1 X149 Y67.5 E0.131 F900 ; 3
G1 X149 Y65.5 E0.131 F900 ; 3
G1 X147 Y65.5 E0.131 F900 ; 3
G1 X147 Y67.5 F12000 ; move to start
G1 X149 Y67.5 E0.131 F900 ; 3
G1 E-0.4 F1800 ; retract
G1 Z0.4 F900 ; zHop
G1 X143 Y75.5 F12000 ; move to start
G1 Z0.3 F900 ; zHop
G1 E0.4 F1800 ; un-retract
G1 X145 Y75.5 E0.131 F900 ; 0
G1 X145 Y77.5 E0.131 F900 ; 0
G1 X145 Y79.5 E0.131 F900 ; 0
G1 X143 Y79.5 E0.131 F900 ; 0
G1 X143 Y77.5 E0.131 F900 ; 0
G1 X143 Y75.5 E0.131 F900 ; 0
G1 E-0.4 F1800 ; retract
G1 X146 Y75.5 F12000 ; move to start
G1 E0.4 F1800 ; un-retract
G1 X146 Y75.9 E0.0262 F900 ; dot
G1 E-0.4 F1800 ; retract
G1 X147 Y75.5 F12000 ; move to start
G1 E0.4 F1800 ; un-retract
G1 X147 Y77.5 F12000 ; move to start
G1 X147 Y79.5 F12000 ; move to start
G1 X147 Y77.5 E0.131 F900 ; 4
G1 X149 Y77.5 E0.131 F900 ; 4
G1 X149 Y79.5 F12000 ; move to start
G1 X149 Y77.5 E0.131 F900 ; 4
G1 X149 Y75.5 E0.131 F900 ; 4
G1 E-0.4 F1800 ; retract
G1 Z0.4 F900 ; zHop
G1 X143 Y85.5 F12000 ; move to start
G1 Z0.3 F900 ; zHop
G1 E0.4 F1800 ; un-retract
G1 X145 Y85.5 E0.131 F900 ; 0
G1 X145 Y87.5 E0.131 F900 ; 0
G1 X145 Y89.5 E0.131 F900 ; 0
G1 X143 Y89.5 E0.131 F900 ; 0
G1 X143 Y87.5 E0.131 F900 ; 0
G1 X143 Y85.5 E0.131 F900 ; 0
G1 E-0.4 F1800 ; retract
G1 X146 Y85.5 F12000 ; move to start
G1 E0.4 F1800 ; un-retract
G1 X146 Y85.9 E0.0262 F900 ; dot
G1 E-0.4 F1800 ; retract
G1 X147 Y85.5 F12000 ; move to start
G1 E0.4 F1800 ; un-retract
G1 X149 Y85.5 E0.131 F900 ; 5
G1 X149 Y87.5 E0.131 F900 ; 5
G1 X147 Y87.5 E0.131 F900 ; 5
G1 X147 Y89.5 E0.131 F900 ; 5
G1 X149 Y89.5 E0.131 F900 ; 5
G1 E-0.4 F1800 ; retract
G1 Z0.4 F900 ; zHop
G1 X143 Y95.5 F12000 ; move to start
G1 Z0.3 F900 ; zHop
G1 E0.4 F1800 ; un-retract
G1 X145 Y95.5 E0.131 F900 ; 0
G1 X145 Y97.5 E0.131 F900 ; 0
G1 X145 Y99.5 E0.131 F900 ; 0
G1 X143 Y99.5 E0.131 F900 ; 0
G1 X143 Y97.5 E0.131 F900 ; 0
G1 X143 Y95.5 E0.131 F900 ; 0
G1 E-0.4 F1800 ; retract
G1 X146 Y95.5 F12000 ; move to start
G1 E0.4 F1800 ; un-retract
G1 X146 Y95.9 E0.0262 F900 ; dot
G1 E-0.4 F1800 ; retract
G1 X147 Y95.5 F12000 ; move to start
G1 E0.4 F1800 ; un-retract
G1 X147 Y97.5 F12000 ; move to start
G1 X149 Y97.5 E0.131 F900 ; 6
G1 X149 Y95.5 E0.131 F900 ; 6
G1 X147 Y95.5 E0.131 F900 ; 6
G1 X147 Y97.5 E0.131 F900 ; 6
G1 X147 Y99.5 E0.131 F900 ; 6
G1 X149 Y99.5 E0.131 F900 ; 6
G1 E-0.4 F1800 ; retract
G1 Z0.4 F900 ; zHop
G1 X143 Y105.5 F12000 ; move to start
G1 Z0.3 F900 ; zHop
G1 E0.4 F1800 ; un-retract
G1 X145 Y105.5 E0.131 F900 ; 0
G1 X145 Y107.5 E0.131 F900 ; 0
G1 X145 Y109.5 E0.131 F900 ; 0
G1 X143 Y109.5 E0.131 F900 ; 0
G1 X143 Y107.5 E0.131 F900 ; 0
G1 X143 Y105.5 E0.131 F900 ; 0
G1 E-0.4 F1800 ; retract
G1 X146 Y105.5 F12000 ; move to start
G1 E0.4 F1800 ; un-retract
G1 X146 Y105.9 E0.0262 F900 ; dot
G1 E-0.4 F1800 ; retract
G1 X147 Y105.5 F12000 ; move to start
G1 E0.4 F1800 ; un-retract
G1 X147 Y107.5 F12000 ; move to start
G1 X147 Y109.5 F12000 ; move to start
G1 X149 Y109.5 E0.131 F900 ; 7
G1 X149 Y107.5 E0.131 F900 ; 7
G1 X149 Y105.5 E0.131 F900 ; 7
G1 E-0.4 F1800 ; retract
G1 Z0.4 F900 ; zHop
G1 X143 Y115.5 F12000 ; move to start
G1 Z0.3 F900 ; zHop
G1 E0.4 F1800 ; un-retract
G1 X145 Y115.5 E0.131 F900 ; 0
G1 X145 Y117.5 E0.131 F900 ; 0
G1 X145 Y119.5 E0.131 F900 ; 0
G1 X143 Y119.5 E0.131 F900 ; 0
G1 X143 Y117.5 E0.131 F900 ; 0
G1 X143 Y115.5 E0.131 F900 ; 0
G1 E-0.4 F1800 ; retract
G1 X146 Y115.5 F12000 ; move to start
G1 E0.4 F1800 ; un-retract
G1 X146 Y115.9 E0.0262 F900 ; dot
G1 E-0.4 F1800 ; retract
G1 X147 Y115.5 F12000 ; move to start
G1 E0.4 F1800 ; un-retract
G1 X147 Y117.5 F12000 ; move to start
G1 X149 Y117.5 E0.131 F900 ; 8
G1 X149 Y115.5 E0.131 F900 ; 8
G1 X147 Y115.5 E0.131 F900 ; 8
G1 X147 Y117.5 E0.131 F900 ; 8
G1 X147 Y119.5 E0.131 F900 ; 8
G1 X149 Y119.5 E0.131 F900 ; 8
G1 X149 Y117.5 E0.131 F900 ; 8
G1 E-0.4 F1800 ; retract
G1 Z0.4 F900 ; zHop
G1 X143 Y125.5 F12000 ; move to start
G1 Z0.3 F900 ; zHop
G1 E0.4 F1800 ; un-retract
G1 X145 Y125.5 E0.131 F900 ; 0
G1 X145 Y127.5 E0.131 F900 ; 0
G1 X145 Y129.5 E0.131 F900 ; 0
G1 X143 Y129.5 E0.131 F900 ; 0
G1 X143 Y127.5 E0.131 F900 ; 0
G1 X143 Y125.5 E0.131 F900 ; 0
G1 E-0.4 F1800 ; retract
G1 X146 Y125.5 F12000 ; move to start
G1 E0.4 F1800 ; un-retract
G1 X146 Y125.9 E0.0262 F900 ; dot
G1 E-0.4 F1800 ; retract
G1 X147 Y125.5 F12000 ; move to start
G1 E0.4 F1800 ; un-retract
G1 X149 Y125.5 E0.131 F900 ; 9
G1 X149 Y127.5 E0.131 F900 ; 9
G1 X147 Y127.5 E0.131 F900 ; 9
G1 X147 Y129.5 E0.131 F900 ; 9
G1 X149 Y129.5 E0.131 F900 ; 9
G1 X149 Y127.5 E0.131 F900 ; 9
G1 E-0.4 F1800 ; retract
G1 Z0.4 F900 ; zHop
;
; FINISH
;
M0
;M107 ; Turn off fan
;M400 ; Finish moving
;M104 S0 ; Turn off hotend
;M140 S0 ; Turn off bed
;G1 Z30 X200 Y200 F12000 ; Move away from the print
;M84 ; Disable motors
;M501 ; Load settings from EEPROM
;
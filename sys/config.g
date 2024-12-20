;
;         	___________                     __         .__                            
;         	\_   _____/___________    _____/  |______  |  |                           
;         	 |    __) \_  __ \__  \ _/ ___\   __\__  \ |  |                           
;         	 |     \   |  | \// __ \\  \___|  |  / __ \|  |__                         
;         	 \___  /   |__|  (____  /\___  >__| (____  /____/                         
;         	     \/               \/     \/          \/                               
;	___________              .__                           .__                
;	\_   _____/ ____    ____ |__| ____   ____   ___________|__| ____    ____  
;	 |    __)_ /    \  / ___\|  |/    \_/ __ \_/ __ \_  __ \  |/    \  / ___\ 
;	 |        \   |  \/ /_/  >  |   |  \  ___/\  ___/|  | \/  |   |  \/ /_/  >
;	/_______  /___|  /\___  /|__|___|  /\___  >\___  >__|  |__|___|  /\___  / 
;	        \/     \//_____/         \/     \/     \/              \//_____/  

; General Setup - RailCore RRF on an SBC for Duet3

; General
G21											; Work in millimetres
G90											; Send absolute coordinates...
M83											; ...but relative extruder moves
M564 S1 H1									; No movement before homing, no out-of-range

G4 S2                                       ; wait for expansion boards to start



; Debugging
M111 S0										; Debug (S0 is off; S1 is on)
M929 P"eventlog.txt" S1						; start logging to file eventlog.txt
M915 X Y S10 F0 R0							; log motor stalls


; Stepper Configuration and Trinamic Drive Tuning
M569 P0.0 S1 D3  V5 H5						; X / Rear - LDO-57STH56-2804MACRC
M569 P0.1 S0 D3  V5 H5						; Y / Front - LDO-57STH56-2804MACRC
M569 P0.2 S1 D3  V5 H5						; Z / FL - LDO-42STH47-1684MAC
M569 P0.3 S1 D3  V5 H5						; Z / RL - LDO-42STH47-1684MAC
M569 P0.4 S1 D3  V5 H5						; Z / MR - LDO-42STH47-1684MAC
;M569 P5 S0 D2  V5 H5						; E / Extruder - LDO-42STH25-1004AC
;M569 P5 S1 D2  V5 H5						; E / Extruder - Biqu H2
;M569 P5 S0 D2  V5 H5						; E / Extruder - Orbiter 2.0
M569 P124.0 S1 D2                           ; E / Extruder - SmorbV3 Toolboard


; Axis configuration
M669 K1										; Corexy mode
;M584 X0 Y1 Z2:3:4 E5						; Map X to drive 0 Y to drive 1, Z to drives 2, 3, 4, and E to drive 5
M584 X0.0 Y0.1 Z0.2:0.3:0.4 E124.0					; Map X to drive 0 Y to drive 1, Z to drives 2, 3, 4, and E to toolboard drive 0
M208 X270 Y290 Z325							; Set axis maxima and high homing switch positions (adjust to suit your machine)
M208 X-35 Y0 Z0 S1 							; Set axis minima and low homing switch positions (adjust to make X=0 and Y=0 the edges of the bed)


; Stealthchop parameters
M915 P0:1	S3 F1 H153 ;T20000 R0				
M915 P2:3:4 S3 F1 H1652 ;T1 R0
;M915 P5 	S3 F1 H540 T1 R0
;M915 P124.0 S3 F1 H540 T1 R0


; Steps/mm (for the default 1/16 microstepping)
M92 X160 Y160 Z1600 						; Axis Steps/mm
;M92 E4206									; FLEX3DRive
;M92 E932									; Biqu H2
M92 E676									; Orbiter 2.0


; Microstepping (independent of M92 above)
M350 X64 Y64 Z16 I1							; Set 32x microstepping for axes with interpolation
;M350 E8 I0									; Set 16x microstepping for Flex3Drive extruder interpolation OFF
;M350 E16 I1								; Biqu H2
M350 E16 I1									; Orbiter 2.0


; Motor current
M906 X{2800 * 0.65} Y{2800 * 0.65} Z{1680 * 0.65} I30			; Set PEAK motor currents (mA) and motor idle factor 
;M906 E420 I30								; Flex3Drive
;M906 E800 I30								; Biqu H2
;M906 E1000 I10								; Orbiter 2.0 (rated 1 amp, recommended 1.2)
M906 E850 I10								; Smorb3.0 (rated 1 amp, recommended 1.2)
M84 S30 									; Idle timeout 30s


; Speeds
M203 X15000 Y15000 Z600 E7200				; Maximum speeds (mm/min) // XY15000(250mm/s), Z600(10mm/s)), E7200 (120mm/s)


; Accelerations and Jerk
M201 X2500 Y2500 Z100						; Accelerations (mm/s^2)
;M201 E120									; Flex3Drive
;M201 E5000									; Biqu H2
;M201 E3000									; Orbiter 2.0
M201 E3000                                  ; Smorb 8000mm/s recommended

M566 X800 Y800 Z100							; Maximum jerk speeds (mm/min) 
;M566 E6									; Flex3Drive
;M566 E300									; Biqu H2
;M566 E300									; Orbiter 2.0
M566 E300                                   ; Smorb 


; Leadscrew locations
M671 X-10:-10:333  Y22.5:277.5:150 S7.5


; End Stops
M574 X1 S1 P"io0.in"						; Map the X endstop to io1.in
;M574 Y1 S1 P"io3.in"						; Map the Y endstop to io2.in
M574 Y1 S1 P"124.io2.in"					; Map the Y endstop to toolboard io1.in
 

; BLTouch
;M558 P9 C"io7.in" H5 R1 F120 T6000 A5 S0.02 B1			; Define the bltouch input on io7.in
;M950 S0 C"io7.out"										; Define the bltouch servo on io7.out
;G31 X0 Y25 Z2.00 P25 									; Set the offsets for the bltouch Flex3Drive
;G31 X-25 Y0 Z1.814 P25 								; Set the offsets for the bltouch Biqu H2
;G31 K0 P25 X0.0 Y20.0 Z2.924 							; Set the offsets for the bltouch Orbiter 2.0

; Euclid Probe
M574 Z1 S2                                              ; configure Z-probe endstop for low end on Z
M558 K0 P8 C"124.io0.in" H8 F300 T9000 A3 S0.01         ; Define Euclid input
G31 K0 P500 X25.0 Y0.0 Z1.486                            ; Set offset for Smorb V3 Euclid

; Thermistors
M308 S0 P"temp0" Y"thermistor" A"Keenovo" T100000 B4240 H0 L0 						; Bed thermistor - connected to temp0
;M308 S1 P"temp1" Y"thermistor" A"Mosquito" T4606017 B5848 C5.548428e-8 H0 L0		; Dyze 500c thermistor - connected to e0_heat
;M308 S1 P"temp1" Y"thermistor" A"BiquH2" T100000 B3950 C0 H0 L0					; Biqu H2 Chinesium HT-NTC100K thermistor - connected to e0_heat
;M308 S1 P"124.temp0" Y"thermistor" A"Smorb" T100000 B4138 C0 H0 L0                  ; Smorb ATC Semitec 104NT-4-R025H42G 
M308 S1 P"124.temp0" Y"thermistor" A"Smorb"  T100000 B4681 C6.483003e-8 H0 L0                  ; Smorb ATC Semitec 104NT-4-R025H42G 

; M308 S3 P"124.io1.in" Y"thermistor" A"Extruder Temp" T100000 B4092                  ; Smorb extruder temp (not supported)

; Define Heaters
M950 H0 C"out0" T0							; Bed heater is on out0
;M950 H1 C"out1" T1	Q10						; Hotend heater is on out1
M950 H1 C"124.out0" T1 Q250					; Hotend heater is on toolboard out0


; Heater model parameters
M307 H0 A158.5 C366.7 D2.1 S1.0 V24.0 B0 		; Keenovo duet 3 configuration
;M307 H1 R3.573 C131.3:99.7 D5.74 S1.00 V29.4           	; Mosquito 205deg 29.4V
;M307 H1 R3.368 K0.543:0.000 D7.05 E1.35 S1.00 B0 V29.3      ; Mosquito new model 215c 29.3V
;M307 H1 R4.724 C172.5:109.0 D7.70 S1.00 V29.4	; Biqu H2 205deg 29.4V
M307 H1 R4.017 K0.408:0.270 D6.28 E1.35 S1.00 B0 V29.4      ; Smorb temp 215c 29.3V



; Heater Fault Parameters
M570 H1 P10 T15 S180						; Hotend allows 10sec for anomaly, permits 15deg excursion, abandons print after 180s
M143 H1 P1 S350 A0							; raise a heater fault if it exceeds 350C		


; Define Bed
M140 H0
M557 X30:295 Y5:285 P15:15 					; Sets mesh leveling probing area /!\ Accounts for probe offset 


; Fans
;M950 F0 C"out5" Q250						; Hotend fan on "out5" connector
;M106 P0 C"Hotend Fan" H1 X0.8 T75 B0.3		; Enable thermostatic mode for hotend fan - 0.8 to compensate for 29.4V 
;M950 F1 C"out4" Q250						; Layer fan on "out4" connector
;M106 P1 C"Layer Fan" X0.8 S0 				; Layer Fan
M950 F0 C"124.out1" Q500					; Hotend fan on "out5" connector
M106 P0 C"Hotend Fan" H1 T75 X0.8     		; Enable thermostatic mode for hotend fan - 0.8 to compensate for 29.4V 
M950 F1 C"124.out2" Q500					; Layer fan on "out4" connector
M106 P1 C"Layer Fan" H-1 S0 X0.8			; Layer Fan

; Tool definitions
M563 P0 S"Smorb v3" D0 H1 F1                ; Define tool 0
G10 P0 S0 R0 								; Set tool 0 operating and standby temperatures


; Duet3 Cooling
M308 S2 Y"drivers" A"DRIVERS" 				; Configure sensor 2 as temperature warning and overheat flags on the TMC2660 on Duet
M308 S3 Y"mcu-temp" A"MCU"					; Configure sensor 3 as thermistor on pin e1temp for left stepper
M950 F2 C"out6" Q250 						; Create fan 2 on pin fan2 and set its frequency                        
;M106 P2 C"ElectroBox" H1 S0.8 T75			; Set fan 2 value
M106 P2 C"ElectroBox" H1 X0.7 T-30:50			; Set fan 2 value
M308 S4 P"124.temp1" Y"thermistor" A"Chamber Temp" T100000 B4092                    ; Toolboard temp


; LED
M950 F3 C"out8" Q1000
M106 P3 C"Enclosure Light" X0.6 S0
M950 C"124.rgbled" E0 T1

M950 F5 C"124.io0.out" Q1000
M106 P5 C"Hotend Light" X0.6 S0


; Filament Sensor
;M591 D0 P7 C"io6.in" S0 E51 L2.1 R85:115   ; Fractal Encoder filament sensor


; Mesh Bed Compensation
;G29 S1 									; Load height map from SD card - Disabled in config.g, moved after startup routing probing
M376 H3										; Set taper height 3mm

; External Triggers
M950 J1 C"io1.in"							; Green Button on io1
M950 J2 C"io4.in"							; Red Button on io4
M950 J3 C"io2.in"							; Black Button on io2
M950 J4 C"io5.in"							; Blue Button on io5

M581 T2 P1 S1 R2							; Green button trigger 2 only when not printing (Load filament)
M581 T3 P1 S1 R1							; Green button trigger 3 only when printing (Raise Z)
M581 T4 P2 S1 R2							; Red button trigger 4 only when not printing (Unload filament)
M581 T5 P2 S1 R1							; Red button trigger 5 only when printing (Stop)
M581 T6 P3 S1 R2							; Black button trigger 6 only when not printing (Resume)
M581 T7 P3 S1 R1							; Black button trigger 7 only when printing (Lower Z)
M581 T8 P4 S1 R2							; Blue button trigger 8 only when not printing (LED strip on/off)
M581 T9 P4 S1 R1							; Blue button trigger 9 only when printing (LED strip on/off)

; Accelerometer
;M955 P0 I21 C"spi.cs3+spi.cs2"              ; LIS3DH removable on Orbiter 2
M955 P124.0 I20                             ; Onboard toolboard

;M593 P"mzv" F42

; Dynamic Acceleration Adjustment (DAA)
;M593 F52


; Logging
M929 P"eventlog.txt" S1 					; start logging to file eventlog.txt

T0											; Select first hot end


; Global Variables

global hotend_timer_started = false
global hotend_timer = 0




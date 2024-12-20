;TPU config.g

;G10 S215 R80                 ; Heat up the current tool to 210C enough for PLA
;M140 S30 R40 	               ; Standby and initial Temp for bed as "off" (-273 = "off")
;M207 S0.4 F1500 T1500 Z0      ; Firmware Retraction 1.2mm , speed 25m/s , deretract 60mm/s, Z-hop 0
;M572 D0 S0.4                ; Pressure advance compensation (if needed to be changed)
;M572 D0 S0
;M204 P1400 T4000             ; General maximum acceleration P(print) T(travel)

;M566 X1200 Y1200 Z60 E3000        ; jerk settings for PLA
;M307 H0 A214.3 C641.7 D1.3 S1.00 V24.0 B0        ; Bed PID tune for 120c
;M307 H1 A491.0 C190.9 D2.8 S1.00 V23.9 B0        ; Hot end PID tune at 280c
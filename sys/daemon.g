; daemon.g

; --------------- Hotend Auto Shut Down at Idle, by Cheeseandham -----------

;check if printing started , if so , ensure the timer start variable if set to false to prevent the logic below switching off the hotend.
if state.status == "processing"
	set global.hotend_timer_started = false

; if the heater is above temp. idle and the timer start flag is currently false, then set the timer to current time and the timer flag true, 
if heat.heaters[1].active >= 150 && heat.heaters[1].state == "active" &&  state.status == "idle" && global.hotend_timer_started = false
	set global.hotend_timer_started = true
	set global.hotend_timer = state.upTime

; check if hotend timer is true and time elpased is more than a set number of seconds. (1200 = 20 minutes)
if global.hotend_timer_started = true && {state.upTime - global.hotend_timer} > 1200
	echo "Hot-end idle timer exceeded. Shutting down"
	M140 S0 R0               ; clear temperatures from DWC
	M140 S-273.1 R0          ; Standby and initial Temp for bed as "off" (-273 = "off")
	G10 P0 S-273.1 R-273.1   ; Set tool 0 operating and standby temperatures(-273 = "off")
	set global.hotend_timer_started = false
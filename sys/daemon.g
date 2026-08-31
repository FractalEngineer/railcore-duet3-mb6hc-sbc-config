; daemon.g

; --------------- Hotend Auto Shut Down at Idle, by Cheeseandham -----------

; If printing starts, cancel any pending idle shutdown.
if state.status == "processing"
	set global.hotend_timer_started = false

; Heater 1 may be temporarily absent while the CAN toolboard starts or is offline.
if #heat.heaters > 1
	; Start the timer when the hotend is commanded to at least 150C while idle.
	if heat.heaters[1].active >= 150 && heat.heaters[1].state == "active" && state.status == "idle" && global.hotend_timer_started = false
		set global.hotend_timer_started = true
		set global.hotend_timer = state.upTime

; Shut down tool 0 after 20 minutes. Do not alter the bed temperature here.
if global.hotend_timer_started = true && {state.upTime - global.hotend_timer} > 1200
	echo "Hot-end idle timer exceeded. Shutting down"
	G10 P0 S-273.1 R-273.1   ; Set tool 0 operating and standby temperatures(-273 = "off")
	set global.hotend_timer_started = false

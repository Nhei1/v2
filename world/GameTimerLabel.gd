extends Label

func update_timer(minutes, seconds):
	text = "%02d:%02d" % [minutes, seconds]

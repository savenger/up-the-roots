extends Spatial

func _set_splash_timeout():
	var timerSplashScreen = Timer.new()
	timerSplashScreen.connect("timeout", self, "_on_timer_splash_screen_timeout")
	timerSplashScreen.wait_time = 2
	add_child(timerSplashScreen)
	timerSplashScreen.start()
	
func _ready():
	_set_splash_timeout()

func _on_timer_splash_screen_timeout():
	$CenterContainer/Splashscreen.queue_free()

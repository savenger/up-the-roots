extends Spatial

var current_player_chunk_pos: Vector2
var cb = preload("res://src/levels/city_building.tscn")

func _set_splash_timeout():
	var timerSplashScreen = Timer.new()
	timerSplashScreen.connect("timeout", self, "_on_timer_splash_screen_timeout")
	timerSplashScreen.wait_time = 2
	timerSplashScreen.one_shot = true
	add_child(timerSplashScreen)
	timerSplashScreen.start()


func _on_timer_splash_screen_timeout():
	$CenterContainer.queue_free()


# Called when the node enters the scene tree for the first time.
func _ready():
	_set_splash_timeout()
	current_player_chunk_pos.x = -1000
	current_player_chunk_pos.y = -1000

func pos_to_chunk_pos(position):
	var x = floor(position.x / (5 * 128))
	var z = floor(position.z / (5 * 128))
	return Vector2(x, z)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var chunk_pos: Vector2 = pos_to_chunk_pos($Player.global_transform.origin)
	
	if chunk_pos.x != current_player_chunk_pos.x or chunk_pos.y != current_player_chunk_pos.y:
		current_player_chunk_pos = chunk_pos
		$level_generator.generate_tiles(chunk_pos)
	$SunLight.rotate(Vector3.BACK, 1 * -delta * 0.05)

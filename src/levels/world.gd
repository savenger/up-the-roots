extends Spatial

var current_player_chunk_pos: Vector2
var cb = preload("res://src/levels/city_building.tscn")
var nearest_collectable = null

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

func get_nearest_collectable(player_pos):
	var dist = 999999
	var nearest = null
	#for vec in LevelData.collectable_locations:
	#	if Vector2(player_pos.x, player_pos.z) - vec < dist:
	#		nearest = vec
	#		dist = player_pos - vec
	return nearest

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var chunk_pos: Vector2 = pos_to_chunk_pos($Player.global_transform.origin)
	
	if chunk_pos.x != current_player_chunk_pos.x or chunk_pos.y != current_player_chunk_pos.y:
		current_player_chunk_pos = chunk_pos
		nearest_collectable = get_nearest_collectable($Player.global_transform.origin)
		$level_generator.generate_tiles(chunk_pos)
	#$SunLight.light_energy = lerp(0, 3, $SunLight.rotation_degrees.x - 10)
	#$MoonLight.light_energy = lerp(0, 3, $MoonLight.rotation_degrees.x - 10)
	print("SunLight rotatoin: %s" % str($SunLight.rotation_degrees.x))
	print("MoonLight rotatoin: %s" % str($SunLight/MoonLight.rotation_degrees.x))
	$SunLight.rotate(Vector3.BACK, 1 * -delta * 0.05 * 10)

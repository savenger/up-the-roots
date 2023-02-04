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
	var x = floor(position.x / (LevelData.CHUNK_SIZE * LevelData.TILE_SIZE))
	var z = floor(position.z / (LevelData.CHUNK_SIZE * LevelData.TILE_SIZE))
	return Vector2(x, z)

func get_nearest_collectable(player_pos):
	var dist = 999999
	var nearest = null
	for vec in LevelData.collectable_locations:
		var d = player_pos.distance_to(vec)
		if  d < dist:
			nearest = vec
			dist = d
	return nearest


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var chunk_pos: Vector2 = pos_to_chunk_pos($Player.global_transform.origin)
	
	if chunk_pos.x != current_player_chunk_pos.x or chunk_pos.y != current_player_chunk_pos.y:
		current_player_chunk_pos = chunk_pos
		$Player.set_nearest_collectable(get_nearest_collectable($Player.global_transform.origin))
		$level_generator.generate_tiles(chunk_pos)

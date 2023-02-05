extends Spatial

var current_player_chunk_pos: Vector2
var cb = preload("res://src/levels/city_building.tscn")
var collectable = preload("res://src/collectables/collectable_menu_item.tscn")

onready var _menu = $Menu/ScrollContainer/Collection

var current_track = 0
var music_files = [
	"res://assets/audio/anotherSunrise.mp3",
	"res://assets/audio/melancholy.mp3",
	"res://assets/audio/tragedy.mp3"
]
var music_streams = []

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
	for m in range(len(music_files)):
		var f = File.new()
		f.open(music_files[m], File.READ)
		var s = AudioStreamMP3.new()
		s.data = f.get_buffer(f.get_len())
		music_streams.append(s)
	_set_splash_timeout()
	current_player_chunk_pos.x = -1000
	current_player_chunk_pos.y = -1000
	start_music()

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


func pause():
	# show / hide menu
	var new_pause_state: bool = not get_tree().paused
	if new_pause_state:
		$Menu.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		$Menu.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	print("get_tree().paused: {paused}".format({"paused": get_tree().paused}))
	get_tree().paused = new_pause_state
	for c in _menu.get_children():
		_menu.remove_child(c)
		c.queue_free()
	for size in range(3):
		for c in LevelData.collectable_count[size]:
			var cmi = collectable.instance()
			cmi.found = (c in LevelData.collection[size])
			cmi.size = size
			cmi.sprite = c
			print("adding sprite %s from size %s" % [str(cmi.sprite), str(cmi.size)])
			_menu.add_child(cmi)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var chunk_pos: Vector2 = pos_to_chunk_pos($Player.global_transform.origin)
	
	if Input.is_action_just_released("volume_up"):
		LevelData.volume_up()
	if Input.is_action_just_released("volume_down"):
		LevelData.volume_down()
	
	if Input.is_action_just_pressed("menu"):
		pause()
	
	if chunk_pos.x != current_player_chunk_pos.x or chunk_pos.y != current_player_chunk_pos.y:
		current_player_chunk_pos = chunk_pos
		$Player.set_nearest_collectable(get_nearest_collectable($Player.global_transform.origin))
		$level_generator.generate_tiles(chunk_pos)
	
	AudioServer.get_bus_effect(AudioServer.get_bus_index("Wind"), 1).cutoff_hz = $Player.global_transform.origin.y * 40 + 80
	$ASP_Wind.volume_db = range_lerp($Player.global_transform.origin.y , 0, 200, -10, 0)


func start_music():
	current_track = (current_track + 1) % len(music_streams)
	$BackgroundMusic.stream = music_streams[current_track]
	$BackgroundMusic.play()

func _on_BackgroundMusic_finished():
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "start_music")
	timer.one_shot = true
	timer.wait_time = 0.1
	timer.start()


func _on_btnResume_pressed():
	pause()


func _on_btnExit_pressed():
	get_tree().quit()


func _on_btnVolumeUp_pressed():
	LevelData.volume_up()


func _on_btnVolumeDown_pressed():
	LevelData.volume_down()

extends Spatial

var current_player_chunk_pos: Vector2
var cb = preload("res://src/levels/city_building.tscn")


var last_output = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.connect("debug_output", self, "_on_debug_output_pressed")
	current_player_chunk_pos.x = -1000
	current_player_chunk_pos.y = -1000

func _on_debug_output_pressed():
	var chunk_pos: Vector2 = pos_to_chunk_pos($Player.global_transform.origin)
	print($Player.global_transform.origin)
	print(chunk_pos)
	print(current_player_chunk_pos)

func pos_to_chunk_pos(position):
	var x = floor(position.x / (5 * 128))
	var z = floor(position.z / (5 * 128))
	return Vector2(x, z)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var chunk_pos: Vector2 = pos_to_chunk_pos($Player.global_transform.origin)
	
	last_output += delta
	if last_output > 1:
		last_output = 0
	if chunk_pos.x != current_player_chunk_pos.x or chunk_pos.y != current_player_chunk_pos.y:
		current_player_chunk_pos = chunk_pos
		$level_generator.generate_tiles(chunk_pos)

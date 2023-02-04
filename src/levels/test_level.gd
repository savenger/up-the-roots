extends Spatial

var rng = RandomNumberGenerator.new()
var current_player_chunk_pos: Vector2
var cb = preload("res://src/levels/city_building.tscn")


var last_output = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	current_player_chunk_pos.x = -1000
	current_player_chunk_pos.y = -1000
	rng.randomize()
#	for x in range(50):
#		for y in range(50):
#			var c = cb.instance()
#			if rng.randf_range(0, 10.0) >= 2.0:
#				c.rotation = Vector3(0, PI / 2, 0)
#			c.transform.origin.x = c.transform.origin.x + x * 128
#			c.transform.origin.z = c.transform.origin.z + y * 128
#			add_child(c)

func pos_to_chunk_pos(position):
	var x = int(position.x / (10 * 128))
	var z = int(position.z / (10 * 128))
	return Vector2(x, z)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var chunk_pos: Vector2 = pos_to_chunk_pos($Player.global_transform.origin)
	
	last_output += delta
	if last_output > 1:
		last_output = 0
		print($Player.global_transform.origin)
		print(chunk_pos)
		print(current_player_chunk_pos)
	if chunk_pos.x != current_player_chunk_pos.x or chunk_pos.y != current_player_chunk_pos.y:
		current_player_chunk_pos = chunk_pos
		print("LOPFOR")
		$level_generator.generate_buildings(chunk_pos)

class_name LevelGeneration extends Node

const CHUNK_SIZE = 100
const TILE_SIZE = 128
var rng = RandomNumberGenerator.new()
var cb = preload("res://src/levels/city_building.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func generate_buildings(position: Vector2):
	generate_buildings_in_chunk(position)
	var x = abs(position.x / 100)
	var z = abs(position.y / 100)
	for i in range(3):
		for j in range(3):
			var chunk_pos = Vector2(x + i - 1, z + j - 1)
			if not buldings_present_in_chunk(chunk_pos):
				generate_buildings_in_chunk(chunk_pos)


func buldings_present_in_chunk(chunk_position):
	if LevelData.map.has(chunk_position.x):
		if LevelData.map.has(chunk_position.y):
			return false
	return true


func generate_buildings_in_chunk(chunk_position):
	# generate chunks around in 1 "chunk radius" (1 chunk = 100 x 100m)
	for x in range(CHUNK_SIZE):
		for z in range(CHUNK_SIZE):
			var c = cb.instance()
			var r = rng.randf_range(0, 4.0)
			if r <= 1.0:
				c.rotation = Vector3(0, PI / 4, 0)
			elif r <= 2.0:
				c.rotation = Vector3(0, PI / 2, 0)
			elif r <= 3.0:
				c.rotation = Vector3(0, 3 * PI / 4, 0)
			c.transform.origin.x = c.transform.origin.x + x * TILE_SIZE
			c.transform.origin.z = c.transform.origin.z + z * TILE_SIZE
			add_child(c)

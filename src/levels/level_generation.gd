class_name LevelGeneration extends Node

const CHUNK_SIZE = 10
const TILE_SIZE = 128
var rng = RandomNumberGenerator.new()
var cb = preload("res://src/levels/city_building.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func generate_buildings(position: Vector2):
	print("have go generate bulding in %s, %s and around" % [str(position.x), str(position.y)])
	if not buldings_present_in_chunk(position):
		generate_buildings_in_chunk(position)
	var x = floor(position.x / (CHUNK_SIZE * TILE_SIZE))
	var z = floor(position.y / (CHUNK_SIZE * TILE_SIZE))
	for i in range(3):
		for j in range(3):
			var chunk_pos = position + Vector2(x + i - 1, z + j - 1)
			print("around would be %s, %s" % [str(chunk_pos.x), str(chunk_pos.y)])
			if not buldings_present_in_chunk(chunk_pos):
				generate_buildings_in_chunk(chunk_pos)
	print("This is the map:")
	print(LevelData.map)


func buldings_present_in_chunk(chunk_position):
	if LevelData.map.has(chunk_position.x):
		if LevelData.map[chunk_position.x].has(chunk_position.y):
			#print("buldings_present_in_chunk(x: %s, y: %s)" % [str(chunk_position.x), str(chunk_position.y)])
			return true
	return false


func generate_buildings_in_chunk(chunk_position):
	#print("generate_buildings_in_chunk (x: %s, y: %s)" % [str(chunk_position.x), str(chunk_position.y)])
	# generate chunks around in 1 "chunk radius" (1 chunk = 100 x 100m)
	for x in range(CHUNK_SIZE):
		for z in range(CHUNK_SIZE):
			var r = rng.randf_range(0, 4.0)
			var c = cb.instance()
			if r <= 1.0:
				c = cb.instance() # TODO: use different building objects
			elif r <= 2.0:
				c = cb.instance() # TODO: use different building objects
			elif r <= 3.0:
				c = cb.instance() # TODO: use different building objects
			r = rng.randf_range(0, 4.0)
			if r <= 1.0:
				c.rotation = Vector3(0, PI / 2, 0)
			elif r <= 2.0:
				c.rotation = Vector3(0, PI, 0)
			elif r <= 3.0:
				c.rotation = Vector3(0, 3 * PI / 2, 0)
			add_child(c)
			c.global_transform.origin.x = chunk_position.x * CHUNK_SIZE * TILE_SIZE + x * TILE_SIZE
			c.global_transform.origin.z = chunk_position.y * CHUNK_SIZE * TILE_SIZE + z * TILE_SIZE
			print("that is: %s, %s" % [str(c.global_transform.origin.x), str(c.global_transform.origin.z)])
	if not LevelData.map.has(chunk_position.x):
		LevelData.map[chunk_position.x] = Dictionary()
	LevelData.map[chunk_position.x][chunk_position.y] = 1

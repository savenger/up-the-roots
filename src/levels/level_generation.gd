class_name LevelGeneration extends Node

const CHUNK_SIZE = 10
const TILE_SIZE = 128
var rng = RandomNumberGenerator.new()
var tiles = []
var collectables = []


# Called when the node enters the scene tree for the first time.
func _ready():
	tiles.append(preload("res://src/levels/city_building.tscn"))
	collectables.append(preload("res://src/collectables/collectable.tscn"))


func generate_buildings(position: Vector2):
	print("have go generate bulding in %s, %s and around" % [str(position.x), str(position.y)])
	if not buldings_present_in_chunk(position):
		var c = collectables[0].instance()
		c.size = 2
		add_child(c)
		c.global_transform.origin.x = position.x * CHUNK_SIZE * TILE_SIZE
		c.global_transform.origin.y = 3 #+ randi() % 100
		c.global_transform.origin.z = position.y * CHUNK_SIZE * TILE_SIZE
		generate_buildings_in_chunk(position)
	for i in range(3):
		for j in range(3):
			var chunk_pos = Vector2(position.x + i - 1, position.y + j - 1)
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


func get_random_tile():
	var t = tiles[randi() % len(tiles)].instance()
	var r = rng.randf_range(0, 4.0)
	if r <= 1.0:
		t.rotation = Vector3(0, PI / 2, 0)
	elif r <= 2.0:
		t.rotation = Vector3(0, PI, 0)
	elif r <= 3.0:
		t.rotation = Vector3(0, 3 * PI / 2, 0)
	return t


func generate_buildings_in_chunk(chunk_position):
	#print("generate_buildings_in_chunk (x: %s, y: %s)" % [str(chunk_position.x), str(chunk_position.y)])
	# generate chunks around in 1 "chunk radius" (1 chunk = 100 x 100m)
	for x in range(CHUNK_SIZE):
		for z in range(CHUNK_SIZE):
			var r = rng.randf_range(0, 4.0)
			var t = get_random_tile()
			add_child(t)
			t.global_transform.origin.x = chunk_position.x * CHUNK_SIZE * TILE_SIZE + x * TILE_SIZE - TILE_SIZE / 2
			t.global_transform.origin.z = chunk_position.y * CHUNK_SIZE * TILE_SIZE + z * TILE_SIZE - TILE_SIZE / 2
			if x == 0 and z == 0:
				print("that is: %s, %s" % [str(t.global_transform.origin.x), str(t.global_transform.origin.z)])
	if not LevelData.map.has(chunk_position.x):
		LevelData.map[chunk_position.x] = Dictionary()
	LevelData.map[chunk_position.x][chunk_position.y] = 1

class_name LevelGeneration extends Node

const MAIN_OFFSET = 1
const BUILDING_WIDTH = 64
const STORY_HEIGHT = 16
const FUNDAMENT_HEIGHT = 3.66
const FLOOR_HEIGHT = 0.8
var rng = RandomNumberGenerator.new()
var building_ground = preload("res://src/levels/building_ground.tscn")
var building_entrance = preload("res://src/levels/OfficeEntrance.tscn")
var stairs_entrance = preload("res://src/levels/StairsEntrance.tscn")
var stairs_roof = preload("res://src/levels/StairsRoof.tscn")
var stairs = preload("res://src/levels/Stairs.tscn")
var tiles = [
	preload("res://src/levels/city_building.tscn")
]
var parks = [
	preload("res://src/levels/Park.tscn"),
	preload("res://src/levels/RuinTileFertig.tscn")
]
var trees = [
	preload("res://src/levels/BigTree.tscn")
]
var windows = [
	preload("res://src/levels/Windows.tscn"),
]
var storys = [
	preload("res://src/levels/Office.tscn"),
	preload("res://src/levels/OfficeBottomDamaged.tscn"),
	preload("res://src/levels/OfficeSideDamaged.tscn"),
	preload("res://src/levels/OfficeTopDamaged.tscn")
]
var props = [
	preload("res://src/levels/Cactus.tscn"),
	preload("res://src/levels/OfficePlant.tscn"),
	preload("res://src/levels/StandingDeskHigh.tscn"),
	preload("res://src/levels/StandingDeskHighEmpty.tscn"),
	preload("res://src/levels/StandingDeskLow.tscn"),
	preload("res://src/levels/StandingDeskLowEmpty.tscn"),
	preload("res://src/levels/BuschSimpleBlau.tscn"),
	preload("res://src/levels/BuschSimpleGelb.tscn"),
	preload("res://src/levels/Chair.tscn"),
	preload("res://src/levels/ChairBroken.tscn"),
	preload("res://src/levels/FLatScreen.tscn"),
	preload("res://src/levels/Rock.tscn"),
	preload("res://src/levels/Table.tscn"),
	preload("res://src/levels/TableBroken.tscn"),
	preload("res://src/levels/WoodenBox.tscn"),
]
var collectables = []


# Called when the node enters the scene tree for the first time.
func _ready():
	collectables.append(preload("res://src/collectables/collectable.tscn"))


func generate_tiles(position: Vector2):
	print("have go generate tile in %s, %s and around" % [str(position.x), str(position.y)])
	if not tiles_present_in_chunk(position):
		generate_tiles_in_chunk(position)
	for i in range(3):
		for j in range(3):
			var chunk_pos = Vector2(position.x + i - 1, position.y + j - 1)
			# print("around would be %s, %s" % [str(chunk_pos.x), str(chunk_pos.y)])
			if not tiles_present_in_chunk(chunk_pos):
				generate_tiles_in_chunk(chunk_pos)


func tiles_present_in_chunk(chunk_position):
	if LevelData.map.has(chunk_position.x):
		if LevelData.map[chunk_position.x].has(chunk_position.y):
			#print("tiles_present_in_chunk(x: %s, y: %s)" % [str(chunk_position.x), str(chunk_position.y)])
			return true
	return false


func generate_collectable():
	var c = collectables[randi() % len(collectables)].instance()
	var r = rng.randi() % 3
	c.size = r
	c.sprite = rng.randi() % LevelData.collectable_count[r]
	return c

func generate_prop():
	var c = props[randi() % len(props)].instance()
	return c

func move_prop_randomly(prop):
	var r = rng.randi() % 3
	if r == 0:
		prop.transform.origin.x += BUILDING_WIDTH / 4
		prop.transform.origin.z -= BUILDING_WIDTH / 4
	elif r == 1:
		prop.transform.origin.x += BUILDING_WIDTH / 4
		prop.transform.origin.z += BUILDING_WIDTH / 4
	else:
		prop.transform.origin.x -= BUILDING_WIDTH / 4
		prop.transform.origin.z += BUILDING_WIDTH / 4
	return prop

func generate_building_procedural(create_collectable):
	# stack `height` storys together, each one rotated separately
	var n = StaticBody.new()
	var g = building_ground.instance()
	g.transform.origin.y = MAIN_OFFSET
	n.add_child(g)
	var inst = building_entrance.instance()
	n.add_child(inst)
	inst.transform.origin.y = FUNDAMENT_HEIGHT + FLOOR_HEIGHT
	var wd = windows[randi() % len(windows)].instance()
	wd = apply_random_rotation(wd)
	n.add_child(wd)
	wd.transform.origin.y = FUNDAMENT_HEIGHT + FLOOR_HEIGHT
	inst = stairs_entrance.instance()
	inst.transform.origin.y = FUNDAMENT_HEIGHT
	n.add_child(inst)
	var p = generate_prop()
	p.transform.origin.y = FUNDAMENT_HEIGHT + FLOOR_HEIGHT
	p = move_prop_randomly(p)
	n.add_child(p)
	var height = rng.randi() % 15 + 3
	
	if create_collectable:
		var c = generate_collectable()
		n.add_child(c)
		c.transform.origin.y = 10 + STORY_HEIGHT * (rng.randi() % height)
		
	var current_height = STORY_HEIGHT + FUNDAMENT_HEIGHT
	for s in range(height):
		var sr = storys[randi() % len(storys)].instance()
		sr = apply_random_rotation(sr)
		n.add_child(sr)
		sr.transform.origin.y = current_height + FLOOR_HEIGHT
		sr.scale.y = 0.95
		wd = windows[randi() % len(windows)].instance()
		wd = apply_random_rotation(wd)
		n.add_child(wd)
		wd.transform.origin.y = current_height  + FLOOR_HEIGHT
		
		p = generate_prop()
		p = apply_random_rotation(p)
		p.transform.origin.y = current_height + FLOOR_HEIGHT
		p = move_prop_randomly(p)
		n.add_child(p)
		
		if s < height:
			var stairs_instance = stairs.instance()
			n.add_child(stairs_instance)
			stairs_instance.transform.origin.y = current_height
		current_height += STORY_HEIGHT
	var stairs_roof_instance = stairs_roof.instance()
	stairs_roof_instance.transform.origin.y = current_height
	n.add_child(stairs_roof_instance)
	# add props
	return n


func generate_building(create_collectable: bool):
	var use_static = (rng.randf_range(0, 10.0) <= 1.0)
	if use_static:
		var s = tiles[randi() % len(tiles)].instance() 
		s.transform.origin.y = MAIN_OFFSET
		return s
	return generate_building_procedural(create_collectable)


func generate_park():
	# TODO: generate park
	return parks[randi() % len(parks)].instance()

func generate_tree():
	return trees[randi() % len(trees)].instance()

func apply_random_rotation(o):
	var r = rng.randf_range(0, 4.0)
	if r <= 1.0:
		o.rotation = Vector3(0, PI / 2, 0)
	elif r <= 2.0:
		o.rotation = Vector3(0, PI, 0)
	elif r <= 3.0:
		o.rotation = Vector3(0, 3 * PI / 2, 0)
	return o


func get_random_tile(create_collectable: bool):
	# generate either a building or a park
	var r = rng.randf_range(0, 10.0)
	var t = null
	if create_collectable:
		t = generate_building(create_collectable)
	else:
		if r <= 9.0:
			t = generate_building(create_collectable)
		else:
			t = generate_park()
			t.transform.origin.y = MAIN_OFFSET
	
	t = apply_random_rotation(t)
	return t


func generate_tiles_in_chunk(chunk_position):
	#print("generate_tiles_in_chunk (x: %s, y: %s)" % [str(chunk_position.x), str(chunk_position.y)])
	# generate chunks around in 1 "chunk radius" (1 chunk = 100 x 100m)
	var r = rng.randi() % (LevelData.CHUNK_SIZE * LevelData.CHUNK_SIZE)
	for x in range(LevelData.CHUNK_SIZE):
		for z in range(LevelData.CHUNK_SIZE):
			var create_collectable = (x * LevelData.CHUNK_SIZE) + z == int(r)
			var t = get_random_tile(create_collectable)
			add_child(t)
			t.global_transform.origin.x = chunk_position.x * LevelData.CHUNK_SIZE * LevelData.TILE_SIZE + x * LevelData.TILE_SIZE - LevelData.TILE_SIZE / 2
			t.global_transform.origin.z = chunk_position.y * LevelData.CHUNK_SIZE * LevelData.TILE_SIZE + z * LevelData.TILE_SIZE - LevelData.TILE_SIZE / 2
			if create_collectable:
				var height = 0
				for c in t.get_children():
					if c.name == "Collectable":
						height = c.transform.origin.y
						break
				LevelData.collectable_locations.append(t.global_transform.origin + Vector3(0, height, 0))
				print("collectable is here: x:%s, y:%s, z:%s" % [str(t.global_transform.origin.x), str(t.global_transform.origin.y), str(t.global_transform.origin.z)])
			#if x == 0 and z == 0:
			#	print("that is: %s, %s" % [str(t.global_transform.origin.x), str(t.global_transform.origin.z)])
	# place tree between two random tiles
	var rx = rng.randi() % LevelData.CHUNK_SIZE
	var rz = rng.randi() % LevelData.CHUNK_SIZE
	var t = generate_tree()
	add_child(t)
	t.global_transform.origin.x = chunk_position.x * LevelData.CHUNK_SIZE * LevelData.TILE_SIZE + rx * LevelData.TILE_SIZE
	t.global_transform.origin.z = chunk_position.y * LevelData.CHUNK_SIZE * LevelData.TILE_SIZE + rz * LevelData.TILE_SIZE - LevelData.TILE_SIZE / 2
	if not LevelData.map.has(chunk_position.x):
		LevelData.map[chunk_position.x] = Dictionary()
	LevelData.map[chunk_position.x][chunk_position.y] = 1

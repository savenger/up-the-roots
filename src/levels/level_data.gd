extends Node
var map = {}
var collectable_locations = []
var collection = {
	0: [],
	1: [],
	2: []
}
var collectable_count = {
	0: 20,
	1: 7,
	2: 4
}
const CHUNK_SIZE = 4
const TILE_SIZE = 128
var base_volume : int = 0
var music_volume : int = -20

func adjust_volume():
	if get_tree().get_current_scene().name != "World":
		return
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), LevelData.music_volume + LevelData.base_volume)

func volume_up():
	if base_volume < 0:
		base_volume += 5
		adjust_volume()

func volume_down():
	base_volume -= 5
	adjust_volume()

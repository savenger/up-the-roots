extends Node
var map = {}
var collectable_locations = []
var collection = []
const CHUNK_SIZE = 4
const TILE_SIZE = 128
var base_volume : int = 0
var music_volume : int = -20

func adjust_volume():
	if get_tree().get_current_scene().name != "World":
		return
	get_tree().get_current_scene().get_node("BackgroundMusic").volume_db = LevelData.music_volume + LevelData.base_volume

func volume_up():
	base_volume += 5
	adjust_volume()

func volume_down():
	base_volume -= 5
	adjust_volume()

extends Spatial

var rng = RandomNumberGenerator.new()

var cb = preload("res://src/levels/city_building.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	for x in range(50):
		for y in range(50):
			var c = cb.instance()
			if rng.randf_range(0, 10.0) >= 2.0:
				c.rotation = Vector3(0, PI / 2, 0)
			c.transform.origin.x = c.transform.origin.x + x * 128
			c.transform.origin.z = c.transform.origin.z + y * 128
			add_child(c)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

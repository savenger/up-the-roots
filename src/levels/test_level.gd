extends Spatial

var rng = RandomNumberGenerator.new()

var cb = preload("res://src/levels/city_building.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var i = 0
	rng.randomize()
	for x in range(50):
		for y in range(50):
			var c = cb.instance()
			if i == 0:
				i = 1
			#if rng.randf_range(0, 10.0) >= 2.0:
			#	print("yes")
				c.transform.origin = c.transform.origin.rotated(Vector3.UP, 2)
			else:
				i = 0
			c.transform.origin.x = c.transform.origin.x + x * 128
			c.transform.origin.z = c.transform.origin.z + y * 128
			add_child(c)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

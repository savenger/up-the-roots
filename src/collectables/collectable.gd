extends Spatial

export var sprite: int
export var size: int

signal collected

# Called when the node enters the scene tree for the first time.
func _ready():
	print("using size %s" % str(size))
	$StaticBody/Area/CollisionShapeSmall.visible = false
	$StaticBody/Area/CollisionShapeMiddle.visible = false
	$StaticBody/Area/CollisionShapeLarge.visible = false
	$StaticBody/SmallCollectable.visible = false
	$StaticBody/MiddleCollectable.visible = false
	$StaticBody/LargeCollectable.visible = false
	if size == 0:
		$StaticBody/SmallCollectable.frame = sprite
		$StaticBody/SmallCollectable.visible = true
		$StaticBody/Area/CollisionShapeSmall.visible = true
	elif size == 1:
		$StaticBody/MiddleCollectable.frame = sprite
		$StaticBody/MiddleCollectable.visible = true
		$StaticBody/Area/CollisionShapeMiddle.visible = true
	elif size == 2:
		$StaticBody/LargeCollectable.frame = sprite
		$StaticBody/LargeCollectable.visible = true
		$StaticBody/Area/CollisionShapeLarge.visible = true


func _on_Area_body_entered(body):
	LevelData.collectable_locations
	var i = LevelData.collectable_locations.find(global_transform.origin)
	LevelData.collectable_locations.remove(i)
	if body.name == "Player":
		body.collect(size, sprite)
		body.playSFX("achievement");
	queue_free()

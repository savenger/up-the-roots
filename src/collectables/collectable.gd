extends Spatial

export var sprite: int
export var size: int


# Called when the node enters the scene tree for the first time.
func _ready():
	print("using size %s" % str(size))
	$StaticBody/CollisionShapeSmall.visible = false
	$StaticBody/CollisionShapeMiddle.visible = false
	$StaticBody/CollisionShapeLarge.visible = false
	$StaticBody/SmallCollectable.visible = false
	$StaticBody/MiddleCollectable.visible = false
	$StaticBody/LargeCollectable.visible = false
	if size == 0:
		$StaticBody/SmallCollectable.frame = sprite
		$StaticBody/SmallCollectable.visible = true
		$StaticBody/CollisionShapeSmall.visible = true
	elif size == 1:
		$StaticBody/MiddleCollectable.frame = sprite
		$StaticBody/MiddleCollectable.visible = true
		$StaticBody/CollisionShapeMiddle.visible = true
	elif size == 2:
		$StaticBody/LargeCollectable.frame = sprite
		$StaticBody/LargeCollectable.visible = true
		$StaticBody/CollisionShapeLarge.visible = true

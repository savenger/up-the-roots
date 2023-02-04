extends Spatial

export var sprite: int
export var size: int


# Called when the node enters the scene tree for the first time.
func _ready():
	var image = Image.new()
	print("using size %s" % str(size))
	$StaticBody/CollisionShapeSmall.visible = false
	$StaticBody/CollisionShapeMiddle.visible = false
	$StaticBody/CollisionShapeLarge.visible = false
	$StaticBody/SmallCollectable.visible = false
	$StaticBody/MiddleCollectable.visible = false
	$StaticBody/LargeCollectable.visible = false
	if size == 0:
		image.load("res://src/assets/collectibles_smol.jpg")
		$StaticBody/SmallCollectable.frame = sprite
		$StaticBody/SmallCollectable.visible = true
		$StaticBody/CollisionShapeSmall.visible = true
	elif size == 1:
		image.load("res://src/assets/collectibles_middle.jpg")
		$StaticBody/MiddleCollectable.frame = sprite
		$StaticBody/MiddleCollectable.visible = true
		$StaticBody/CollisionShapeMiddle.visible = true
	elif size == 2:
		image.load("res://src/assets/collectibles_large.jpg")
		$StaticBody/LargeCollectable.frame = sprite
		$StaticBody/LargeCollectable.visible = true
		$StaticBody/CollisionShapeLarge.visible = true
	var t = ImageTexture.new()
	t.create_from_image(image)

extends Spatial

export var sprite: int
export var size: int

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var image = Image.new()
	image.load("res://src/assets/collectibles_smol.jpg")
	var t = ImageTexture.new()
	t.create_from_image(image)
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

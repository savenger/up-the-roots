extends Control

export var size: int
export var sprite: int

var hframes = {
	0: 10,
	1: 4,
	2: 1
}

var vframes = {
	0: 7,
	1: 2,
	2: 1
}

var frames = {
	0: 20,
	1: 7,
	2: 4
}

var assets = {
	0: "collectibles_smol.png",
	1: "collectibles_middle.png",
	2: "collectibles_large.png"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.texture = load("res://assets/%s" % assets[size])
	$Sprite.hframes = hframes[size]
	$Sprite.vframes = vframes[size]
	$Sprite.frame = sprite

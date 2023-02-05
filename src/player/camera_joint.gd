extends Spatial

export var mouse_sensitivity := 0.05
export var gamepad_threshold := 0.25

func _ready():
	set_as_toplevel(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	#print(Input.get_joy_axis(0, 2))
	#print(Input.get_joy_axis(0, 3))
	if abs(Input.get_joy_axis(0, 3)) > gamepad_threshold:
		rotation_degrees.x -= Input.get_joy_axis(0, 3) * delta * 200
		rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 30.0)
	if abs(Input.get_joy_axis(0, 2)) > gamepad_threshold:
		rotation_degrees.y -= Input.get_joy_axis(0, 2) * delta * 200
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y * mouse_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 30.0)
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)

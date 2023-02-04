extends KinematicBody

export var acc := 5.0
export var dec := 10.0
export var max_speed := 40.0
export var jump_strength := 40.0
export var gravity := 40.0

var _velocity := Vector3.ZERO
var _snap_vector := Vector3.DOWN

onready var _camera_joint: SpringArm = $CameraJoint

func _physics_process(delta):
	var move_direction := Vector3.ZERO
	move_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move_direction.z = Input.get_action_strength("back") - Input.get_action_strength("forward")
	move_direction = move_direction.rotated(Vector3.UP, _camera_joint.rotation.y).normalized()
	if move_direction.x:
		if abs(_velocity.x) < max_speed:
			_velocity.x += move_direction.x * acc
	else:
		_velocity.x -= _velocity.x * delta
	if move_direction.z:
		if abs(_velocity.z) < max_speed:
			_velocity.z += move_direction.z * acc
	else:
		_velocity.z -= _velocity.z * delta
	_velocity.y -= gravity * delta
	var just_landed := is_on_floor() and _snap_vector == Vector3.ZERO
	var is_jumping := is_on_floor() and Input.is_action_just_pressed("jump")
	if is_jumping:
		_velocity.y = jump_strength
		_snap_vector = Vector3.ZERO
	elif just_landed:
		_snap_vector = Vector3.DOWN
	_velocity = move_and_slide_with_snap(_velocity, _snap_vector, Vector3.UP, true)

func _process(delta):
	_camera_joint.translation = translation

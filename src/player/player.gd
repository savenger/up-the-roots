extends KinematicBody

export var default_speed := 75.0
export var run_speed := 500.0
export var acc := 10.0
export var jump_strength := 300.0
export var jump_acc := 8.0
export var gravity := 700.0
export var max_jump_time := 0.3

var is_jumping = false
var jump_timer = 0

signal debug_output

var _velocity := Vector3.ZERO
var _snap_vector := Vector3.DOWN

onready var _camera_joint: SpringArm = $CameraJoint

func _physics_process(delta):
	var move_direction := Vector3.ZERO
	move_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move_direction.z = Input.get_action_strength("back") - Input.get_action_strength("forward")
	move_direction = move_direction.rotated(Vector3.UP, _camera_joint.rotation.y).normalized()
	var speed = default_speed
	if Input.is_action_pressed("run"):
		speed = run_speed
	_velocity = lerp(_velocity, move_direction * speed, delta * acc) # smooth movement
	_velocity.y -= gravity * delta
	if Input.is_action_just_pressed("debug"):
		emit_signal("debug_output")
	if jump_timer > 0:
		jump_timer -= delta
	var just_landed := is_on_floor() and _snap_vector == Vector3.ZERO
	var jump_now := is_on_floor() and Input.is_action_just_pressed("jump")
	if jump_now:
		is_jumping = true
		jump_timer = max_jump_time
		_snap_vector = Vector3.ZERO
	is_jumping = is_jumping and Input.is_action_pressed("jump") and jump_timer > 0
	if is_jumping:
		_velocity.y += jump_strength * jump_acc * delta
	elif just_landed:
		_snap_vector = Vector3.DOWN
	_velocity = move_and_slide_with_snap(_velocity, _snap_vector, Vector3.UP, true)

func _process(delta):
	_camera_joint.translation = translation

extends KinematicBody

export var default_speed := 30.0
export var run_speed := 500.0
export var root_speed := 10.0
export var default_acc := 10.0
export var run_acc := 2.0
export var jump_strength := 300.0
export var root_travel_speed := 20.0
export var jump_acc := 4.0
export var gravity := 300.0
export var max_jump_time := 0.3

var is_jumping = false
var jump_timer = 0
var root_area_count = 0
var onfloor: bool = false

signal debug_output

var _velocity := Vector3.ZERO

onready var _camera_joint: SpringArm = $CameraJoint

func _physics_process(delta):
	if Input.is_action_just_pressed("debug"):
		emit_signal("debug_output")
	var move_vector := Vector3.ZERO
	move_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move_vector.z = Input.get_action_strength("back") - Input.get_action_strength("forward")
	move_vector = move_vector.rotated(Vector3.UP, _camera_joint.rotation.y).normalized()
	var speed = default_speed
	var acc = default_acc
	var root_travel = root_area_count > 0
	if root_travel:
		speed = root_speed
	elif Input.is_action_pressed("run"):
		speed = run_speed
		acc = run_acc
	move_vector *= speed
	if root_travel:
		move_vector.y = (Input.get_action_strength("jump") - Input.get_action_strength("run")) * root_travel_speed
	else:
		if not onfloor:
			_velocity.y -= gravity * delta
	var jump_now := onfloor and Input.is_action_just_pressed("jump")
	if jump_now:
		is_jumping = true
		jump_timer = max_jump_time
	is_jumping = is_jumping and Input.is_action_pressed("jump") and jump_timer > 0
	if is_jumping:
		_velocity.y += jump_strength * jump_acc * delta
	_velocity = lerp(_velocity, move_vector, delta * acc) # smooth movement
	_velocity = move_and_slide(_velocity, Vector3.UP, true, 2)

func _process(delta):
	_camera_joint.translation = translation
	if jump_timer > 0:
		jump_timer -= delta
	if Input.is_action_just_released("jump"):
		jump_timer = 0

func _on_Sphere_body_entered(body: StaticBody):
	if body.is_in_group("roots"):
		root_area_count += 1
		print(root_area_count)

func _on_Sphere_body_exited(body: StaticBody):
	if body.is_in_group("roots"):
		root_area_count -= 1
		print(root_area_count)

func _on_AreaUnder_body_entered(body):
	if body:
		if body.get_class() == "StaticBody":
			onfloor = true

func _on_AreaUnder_body_exited(body):
	if body:
		if body.get_class() == "StaticBody":
			onfloor = false

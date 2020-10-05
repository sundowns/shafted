extends KinematicBody

enum PlayerState {
	IDLE,
	MOVE,
	AIRBORNE
}

# Player movement values
export(float) var jump_force: float = 10 # Initial vertical impulse when jumping
export(float) var ground_speed: float = 10
export(float) var ground_acceleration: float = 16
export(float) var aerial_speed: float = 14
export(float) var aerial_acceleration: float = 2
export(float) var aerial_drag: float = 8
export(float) var gravity: float = 12
export(float) var crouching_speed_modifier: float = 0.6

onready var camera: Camera = $Head/Camera
onready var head: Spatial = $Head
onready var skybox_cast: RayCast = $Head/SkyboxCast
onready var push_cast: RayCast = $Head/PushCast
onready var interact_cast: RayCast = $Head/InteractCast
onready var fire_timer: Timer = $FireTimer
onready var ground_check: RayCast = $Groundcheck

const highlight_material = preload("res://materials/push_highlight.tres")
const mouse_sensitivity: float = 0.05
const terminal_fall_velocity: float = -25.0
const crouch_offset: float = -0.7

var velocity := Vector3.ZERO
var direction := Vector3.ZERO
var state = PlayerState.IDLE
var is_firing: bool = false
var head_position: Vector3 = Vector3.ZERO
var is_crouching: bool = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	head_position = head.transform.origin

func _input(event):
	# Camera look
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))

func _physics_process(delta):
	match state:
		PlayerState.IDLE:
			idle_state(delta)
		PlayerState.MOVE:
			move_state(delta)
		PlayerState.AIRBORNE:
			airborne_state(delta)
	handle_crouching()
	apply_movement()
	handle_interaction()
	handle_push()

func set_state(new_state):
	if state == new_state:
		return
	leave_state(new_state, state)
	state = new_state

func leave_state(_new_state, _previous_state):
	pass

func idle_state(delta):
	grounded_movement(delta)
	handle_jump()
	
	if not is_on_floor() and not ground_check.is_colliding():
		set_state(PlayerState.AIRBORNE)
		return
	if direction != Vector3.ZERO:
		set_state(PlayerState.MOVE) 
		return

func move_state(delta):
	grounded_movement(delta)
	handle_jump()
	if direction == Vector3.ZERO:
		set_state(PlayerState.IDLE)
		return
	if not is_on_floor() and not ground_check.is_colliding():
		set_state(PlayerState.AIRBORNE)

func airborne_state(delta):
	aerial_movement(delta)
	handle_gravity(delta)
	if is_on_floor() or ground_check.is_colliding():
		set_state(PlayerState.MOVE)
		return

func grounded_movement(delta):
	direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x

	direction = direction.normalized()
	var effective_ground_accel = ground_acceleration
	var effectve_ground_speed = ground_speed
	if is_crouching:
		effectve_ground_speed = effectve_ground_speed * crouching_speed_modifier
		effective_ground_accel = effective_ground_accel * crouching_speed_modifier
	velocity = velocity.linear_interpolate(direction * effectve_ground_speed, effective_ground_accel * delta)
	if abs(velocity.x) > 4 or abs(velocity.z) > 4: 
		AudioManager.playFootstep()

func aerial_movement(delta):
	direction = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
		
	direction = direction.normalized()
	if direction != Vector3.ZERO:
		velocity = velocity.linear_interpolate(direction * aerial_speed, aerial_acceleration * delta)
	velocity = velocity.move_toward(Vector3(0, velocity.y, 0), delta * aerial_drag)
	handle_ceiling_collision()

func apply_movement():
	if velocity != Vector3.ZERO:
		move_and_slide(velocity, Vector3.UP)

func handle_jump():
	if Input.is_action_just_pressed("jump") and (is_on_floor() or ground_check.is_colliding()):
		velocity.y = (Vector3.UP * jump_force).y

func handle_gravity(delta):
	if not is_on_floor() and not ground_check.is_colliding():
		var modifier := 1.0
		if velocity.y <= 0:
			modifier = 1.5
		velocity += Vector3.DOWN * gravity * delta * modifier
		velocity.y = max(velocity.y, terminal_fall_velocity)

func handle_ceiling_collision():
	if is_on_ceiling() and velocity.y > 0:
		velocity.y = 0

func handle_push():
	if Input.is_action_just_pressed("fire"):
		is_firing = true
		fire_timer.start()
	
	if push_cast.is_colliding():
		var projectile = push_cast.get_collider()
		projectile.highlight(highlight_material)
		
		if skybox_cast.is_colliding() and is_firing:
			var target_position = skybox_cast.get_collision_point()
			if projectile is Arrow:
				projectile.redirect(target_position, push_cast.get_collision_point())
			else:
				print("Warning: Tried to push a non-arrow projectile somehow...")
			is_firing = false
			fire_timer.stop()

func handle_crouching():
	if Input.is_action_pressed("crouch"):
		is_crouching = true
		head.transform.origin = head_position + Vector3(0, crouch_offset, 0)
	else:
		is_crouching = false
		head.transform.origin = head_position

func handle_interaction():
	if interact_cast.is_colliding():
		var collider = interact_cast.get_collider()
		if collider is Interactable:
			var interactable_object = collider.parent
			if interactable_object == null:
				return
			interactable_object.highlight(highlight_material)
			if Input.is_action_just_pressed("interact"):
				interactable_object.activate()

func _on_FireTimer_timeout():
	is_firing = false

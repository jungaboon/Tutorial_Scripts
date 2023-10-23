extends CharacterBody3D


@export var speed = 5.0
@export var cam : Node3D
@export var cam_speed : float = 5
@export var cam_rotation_amount : float = 1

@export var weapon_holder : Node3D
@export var weapon_sway_amount : float = 5
@export var weapon_rotation_amount : float = 1
@export var invert_weapon_sway : bool = false

const JUMP_VELOCITY = 4.5

var def_weapon_holder_pos : Vector3
var mouse_input : Vector2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _input(event):
	if !cam: return
	if event is InputEventMouseMotion:
		cam.rotation.x -= event.relative.y * cam_speed
		cam.rotation.x = clamp(cam.rotation.x,-1.25,1.5)
		self.rotation.y -= event.relative.x * cam_speed
		mouse_input = event.relative

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	def_weapon_holder_pos = weapon_holder.position

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# Note that the negative value for the forward/back movement is "fwd" because Godot's forward is -Z
	var input_dir = Input.get_vector("left","right","fwd","bwd")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
	cam_tilt(input_dir.x, delta)
	weapon_tilt(input_dir.x, delta)
	weapon_sway(delta)
	weapon_bob(velocity.length(),delta)

func cam_tilt(input_x, delta):
	if cam:
		cam.rotation.z = lerp(cam.rotation.z, -input_x * cam_rotation_amount, 10 * delta)

func weapon_tilt(input_x, delta):
	if weapon_holder:
		weapon_holder.rotation.z = lerp(weapon_holder.rotation.z, -input_x * weapon_rotation_amount * 10, 10 * delta)

func weapon_sway(delta):
	mouse_input = lerp(mouse_input,Vector2.ZERO,10*delta)
	weapon_holder.rotation.x = lerp(weapon_holder.rotation.x, mouse_input.y * weapon_rotation_amount * (-1 if invert_weapon_sway else 1), 10 * delta)
	weapon_holder.rotation.y = lerp(weapon_holder.rotation.y, mouse_input.x * weapon_rotation_amount * (-1 if invert_weapon_sway else 1), 10 * delta)	

func weapon_bob(vel : float, delta):
	if weapon_holder:
		if vel > 0 and is_on_floor():
			var bob_amount : float = 0.01
			var bob_freq : float = 0.01
			weapon_holder.position.y = lerp(weapon_holder.position.y, def_weapon_holder_pos.y + sin(Time.get_ticks_msec() * bob_freq) * bob_amount, 10 * delta)
			weapon_holder.position.x = lerp(weapon_holder.position.x, def_weapon_holder_pos.x + sin(Time.get_ticks_msec() * bob_freq * 0.5) * bob_amount, 10 * delta)
			
		else:
			weapon_holder.position.y = lerp(weapon_holder.position.y, def_weapon_holder_pos.y, 10 * delta)
			weapon_holder.position.x = lerp(weapon_holder.position.x, def_weapon_holder_pos.x, 10 * delta)

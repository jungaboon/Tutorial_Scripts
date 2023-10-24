extends Node
class_name RecoilHandler

@export var target_object : Node3D
@export var recoil_rotation_x : Curve
@export var recoil_rotation_z : Curve
@export var recoil_position_z : Curve
@export var recoil_amplitude := Vector3(1,1,1)
@export var lerp_speed : float = 1
@export var recoil_speed : float = 1

@export var camera_shake : CameraShake
@export var camera_shake_amount : float = 0.3

var def_pos : Vector3
var def_rot : Vector3
var target_rot : Vector3
var target_pos : Vector3
var current_time : float

func _ready():
	def_pos = target_object.position
	def_rot = target_object.rotation
	target_rot.y = target_object.rotation.y
	current_time = 1

func _physics_process(delta):
	if current_time < 1:
		current_time += delta * recoil_speed
		target_object.position.z = lerp(target_object.position.z, def_pos.z + target_pos.z, lerp_speed * delta)
		target_object.rotation.z = lerp(target_object.rotation.z, def_rot.z + target_rot.z, lerp_speed * delta)
		target_object.rotation.x = lerp(target_object.rotation.x, def_rot.x + target_rot.x, lerp_speed * delta)
		
		target_rot.z = recoil_rotation_z.sample(current_time) * recoil_amplitude.y
		target_rot.x = recoil_rotation_x.sample(current_time) * -recoil_amplitude.x
		target_pos.z = recoil_position_z.sample(current_time) * recoil_amplitude.z

func apply_recoil():
	camera_shake.add_trauma(camera_shake_amount)
	recoil_amplitude.y *= -1 if randf() > 0.5 else 1
	target_rot.z = recoil_rotation_z.sample(0) * recoil_amplitude.y
	target_rot.x = recoil_rotation_x.sample(0) * -recoil_amplitude.x
	target_pos.z = recoil_position_z.sample(0) * recoil_amplitude.z
	current_time = 0

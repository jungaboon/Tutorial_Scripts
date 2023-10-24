extends Node

@export var weapon : Weapon
@export var recoil_handler : RecoilHandler
@export var animation_player : AnimationPlayer
var can_fire : bool = true
var holding_trigger : bool = false
var shot_time : float = 0

func _input(event):
	fire_weapon_handler(event)

func fire_weapon_handler(event):
	if !weapon: return
	match weapon.shoot_type:
		weapon.ShootType.SINGLE:
			if event.is_action_pressed("fire") and can_fire:
				can_fire = false
				fire()

		weapon.ShootType.SEMI_AUTO:
			if event.is_action_pressed("fire") and can_fire:
				fire()

		weapon.ShootType.FULL_AUTO:
			if event.is_action_pressed("fire"):
				holding_trigger = true
			if event.is_action_released("fire"):
				holding_trigger = false

func _process(delta):
	if holding_trigger:
		shot_time -= delta
		if shot_time < 0:
			fire()
			shot_time = weapon.shot_delay
	else:
		shot_time = 0

func fire():
	print("Shoot")
	if recoil_handler:
		recoil_handler.apply_recoil()
	if animation_player:
		animation_player.play("fire")

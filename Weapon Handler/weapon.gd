extends Node
class_name Weapon

@export var weapon_name : String
@export var ranged : bool = true
@export var max_mag_size : int = 18
@export var ammo_used_per_shot : int = 1
@export var ammo : Ammo

enum ShootType
{
	SINGLE, SEMI_AUTO, FULL_AUTO
}

@export var shoot_type : ShootType

@export var shot_delay : float = 0.1

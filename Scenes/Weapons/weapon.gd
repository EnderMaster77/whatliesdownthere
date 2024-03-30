extends Spawner
class_name Weapon

@export var gun_texture: Texture2D
@export var gun_side_profile: Texture2D


@export var weapon_name: String ## Name Of the Weapon.

@export var weapon_ammo_pack: PackedScene

@export var random_spread: float = 0 ## The range where bullets can randomly travel away from the target.

@export var player_weapon: bool = false ## Turn on if weapon is going to be for player. If for bots, keep turned off.


@export var damage: float = 20.0 ## Damage weapon deals.
@export var mag_size: int = 30 ## Size of magazine.
@export var durability: float = 100 ## The amount of shots required to break a weapon. Setting this value to 0 makes the weapon unbreakable.
@export_enum("AR","Shotgun","Pistol","Energy","Special","Rocket","Sniper") var ammo_type = "AR"

@onready var bullets_in_mag: int = mag_size

var selected: bool = false
var reloading: bool = false
var can_fire: bool = true
var broken: bool = false
var throwing: bool = false

var explosion := preload("res://Scenes/Levels/explosion.tscn")


func reload():
	if reloading == true:
		return
	var added_bullets = mag_size - bullets_in_mag
	if get_parent().get_parent().ammo[ammo_type] <= 0 :
		return
	else:
		$ReloadTimer.start()
		reloading = true
func throw():
	if broken == true:
		throwing = true
		#texture # Set custom texture.
		bulletsPerRadius =1
		bulletType.scale =10
		damage = 200 
		clear_all()
		set_manual_start(true)
func fire():
	if selected == true or player_weapon == false:
		if can_fire == true && reloading == false:
			if (broken == false && bullets_in_mag > 0) or player_weapon == false:
				if random_spread != 0:
					offsetTowardPlayer = 0
					offsetTowardPlayer = RandomNumberGenerator.new().randi_range(-random_spread,random_spread)
				set_manual_start(true)
				can_fire = false
				$Timer.start()
				bullets_in_mag -= 1
				if durability > 0:
					durability -= 1
					if durability <=0:
						broken = true


func _on_timer_timeout() -> void:
	can_fire = true


func _on_bullet_hit(result: Array, bulletIndex: int, spawner: Object) -> void:
	var object_hit: Node2D = result[0]["collider"]
	if object_hit.has_method("damage"):
		object_hit.damage(damage)
	if throwing == true:
			var exploding = explosion.instantiate()
			print(exploding)
			exploding.global_position = object_hit.global_position
			get_parent().get_parent().add_sibling(exploding)
			exploding.global_position = object_hit.global_position
			queue_free()


func _on_reload_timer_timeout() -> void:
	var added_bullets = mag_size - bullets_in_mag
	reloading = false
	if get_parent().get_parent().ammo[ammo_type] - added_bullets <= 0:
		bullets_in_mag = get_parent().get_parent().ammo[ammo_type]
		get_parent().get_parent().ammo[ammo_type] = 0
	else:
		get_parent().get_parent().ammo[ammo_type] -= added_bullets
		bullets_in_mag += added_bullets

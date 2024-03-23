extends Spawner
class_name Weapon

@export var weapon_name: String

@export var player_weapon: bool = false
@export var damage: float = 20.0
@export var mag_size: int = 30
@export var max_bullets_in_storage: int = 120

@export var durability: float = 100 ## The amount of shots required to break a weapon. Setting this value to 0 makes the weapon unbreakable.

@onready var bullets_in_mag: int = mag_size
@onready var bullets_in_storage: int = max_bullets_in_storage
var selected: bool = false
var reloading: bool = false
var can_fire: bool = true
func reload():
	if reloading == true:
		return
	var added_bullets = mag_size - bullets_in_mag
	if bullets_in_storage <= 0 :
		return
	else:
		$ReloadTimer.start()
		reloading = true
func fire():
	if can_fire == true && reloading == false:
		if bullets_in_mag > 0 or player_weapon == false:
			set_manual_start(true)
			can_fire = false
			$Timer.start()
			bullets_in_mag -= 1
			print(bullets_in_mag, " ", bullets_in_storage)
			if durability != 0:
				durability -= 1


func _on_timer_timeout() -> void:
	can_fire = true


func _on_bullet_hit(result: Array, bulletIndex: int, spawner: Object) -> void:
	var object_hit: Node2D = result[0]["collider"]
	if object_hit.has_method("damage"):
		object_hit.damage(damage)


func _on_reload_timer_timeout() -> void:
	var added_bullets = mag_size - bullets_in_mag
	reloading = false
	if bullets_in_storage - added_bullets <= 0:
		bullets_in_mag = bullets_in_storage
		bullets_in_storage = 0
	else:
		bullets_in_storage -= added_bullets
		bullets_in_mag += added_bullets

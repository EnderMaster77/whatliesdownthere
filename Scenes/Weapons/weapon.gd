extends Spawner
class_name Weapon

@export var player_weapon: bool = false
@export var damage: float = 20.0

var selected: bool = true
var can_fire: bool = true

func fire():
	if can_fire == true:
		print("FIRE")
		set_manual_start(true)
		can_fire = false
		$Timer.start()


func _on_timer_timeout() -> void:
	can_fire = true


func _on_bullet_hit(result: Array, bulletIndex: int, spawner: Object) -> void:
	var object_hit: Node2D = result[0]["collider"]
	print("hit ", object_hit)
	if object_hit.has_method("damage"):
		print("doingdamage")
		object_hit.damage(damage)
